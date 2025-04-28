#!/usr/bin/env bash

for temp in ../templates/*.typ; do
  dir=$(dirname $temp)
  base=$(basename $temp)
  name=${base%.*}

  typst compile \
    --root .. \
    --ignore-system-fonts \
    --input lang=de \
    --input flavor=latte \
    --input accent=mauve \
    --input assets=../templates/assets \
    $temp \
    $name.pdf
    
  magick $name.pdf $name.png
  rm -f $name.pdf
done
