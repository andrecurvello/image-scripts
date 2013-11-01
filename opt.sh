#!/bin/sh

# 2013 <johan@expandedactivities.com>

ROOT=$1
mkdir $ROOT/out/
for i in `ls $ROOT | grep .png`; do
  optipng $ROOT/$i -out $ROOT/out/$i
done
