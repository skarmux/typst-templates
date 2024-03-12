#!/usr/bin/env bash

TEMPLATE=$(basename $(gum choose $(ls *.typ)) .typ)

DATA=$(gum choose $(ls ./assets))

cp $TEMPLATE.typ temp.typ
sed -i '1s/curriculum_vitae_sample.toml/'$DATA'/' temp.typ

mkdir -p pdf

gum spin --spinner dot --title "Compiling PDF..." -- \
typst compile temp.typ pdf/$TEMPLATE.pdf

rm temp.typ
