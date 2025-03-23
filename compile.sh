#!/usr/bin/env bash

DATA=$(realpath "$1")

PROJECT_ROOT=$(dirname $(realpath "$0") )

TYP=$PROJECT_ROOT/typst/$(sed -n '1s/# //p' $DATA)

TEMP=$(mktemp)
echo '#let data = toml("'$DATA'")' > $TEMP
sed -e '1d' \
    -e 's:"\./:"'$PROJECT_ROOT'/typst/:' \
    $TYP >> $TEMP

typst compile --root / $TEMP $(basename $DATA .toml).pdf

rm $TEMP
