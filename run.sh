#!/usr/bin/env bash

set -euo pipefail

# NOTE: The typst compiler does follow symlinks, therefore all
#       .typ files need to be copied to the build location

TMP_DIR=$(mktemp -d)

# prepare data file for editing
if [[ ''${1+x} ]] && [[ -f "$1" ]]; then
  CONFIG_JSON=$(sed -n '1s/^# //p' $1)

  TEMPLATE=$(echo $CONFIG_JSON | jq -r ".template")
  LANGUAGE=$(echo $CONFIG_JSON | jq -r ".lang")
  THEME=$(echo $CONFIG_JSON | jq -r ".theme")
  ASSETS=$(echo $CONFIG_JSON | jq -r ".assets")
  FILENAME=$(basename $1 .toml)

  cp $1 $TMP_DIR/data.toml
else
  TEMPLATE=$(basename $(gum file $SRC/templates/) .typ)
  LANGUAGE=$(gum choose "en" "de")
  THEME=$(gum choose "latte" "frappe" "macchiato" "mocha" )
  ASSETS=$SRC/assets
  FILENAME=$(basename $TEMPLATE .typ)

  echo -n "# { \"template\": \"$TEMPLATE\"," > $TMP_DIR/data.toml
  echo -n "\"lang\": \"$LANGUAGE\"," >> $TMP_DIR/data.toml
  echo -n "\"theme\": \"$THEME\"," >> $TMP_DIR/data.toml
  echo "\"assets\": \"$ASSETS\" }" >> $TMP_DIR/data.toml
  echo "" >> $TMP_DIR/data.toml
  cat $SRC/data/$TEMPLATE.toml >> $TMP_DIR/data.toml
fi

cp $SRC/templates/$TEMPLATE.typ $TMP_DIR/template.typ
if [ -f "$SRC/translations/$TEMPLATE.$LANGUAGE.yaml" ]; then
  ln -s "$SRC/translations/$TEMPLATE.$LANGUAGE.yaml" $TMP_DIR/lang.yaml
fi
ln -s $ASSETS $TMP_DIR/assets
cp -r --no-preserve=all $SRC/templates/modules $TMP_DIR/modules
ln -s "$THEME_PATH/$THEME.yaml" $TMP_DIR/modules/colors.yaml

typst watch \
  --root $TMP_DIR \
  --font-path $FONT_PATH \
  "$TMP_DIR/template.typ" \
  "$TMP_DIR/$FILENAME.pdf" \
  &> typst.log &
WATCH_PID=$!

while [ ! -f "$TMP_DIR/$FILENAME.pdf" ]; do
  sleep 0.5
done
evince "$TMP_DIR/$FILENAME.pdf" &> evince.log &
EVINCE_PID=$!

$EDITOR $TMP_DIR/data.toml

kill $WATCH_PID
kill $EVINCE_PID

# no harm in overriding generated pdf as long as the toml exists
cp -v --backup=existing --suffix=.orig "$TMP_DIR/$FILENAME.pdf" ./$FILENAME.pdf
cp -v --backup=existing --suffix=.orig $TMP_DIR/data.toml $FILENAME.toml

rm -rf $TMP_DIR

# cleanup
rm typst.log evince.log
