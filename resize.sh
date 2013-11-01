#!/bin/sh

# 2013 <johan@expandedactivities.com>

# Resize a batch of images (png) without modifying the original
# 
# Resized image is placed in a sub directory named `out`. Within `out` a
# `debug` directory is placed with the name of the image written on top.
# 
# Example:
#   resize <dir>

ROOT=$1
SIZE=$2
OUT=$ROOT/out
rm -rf $OUT
mkdir -p $OUT/debug
for i in `ls $ROOT | grep .png`; do
  convert $ROOT/$i -resize $SIZE $OUT/$i
  convert $ROOT/$i -resize $SIZE -font 'Arial' -draw "text 10,5 '$i'" $OUT/debug/$i
done

