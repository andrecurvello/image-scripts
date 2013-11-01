#!/bin/sh

# 2013 <johan@expandedactivities.com>

# Spritify, helper for creating spritesheets.

# Create a spritesheet using pm and pm-spritesheet of the given directory.
# If the images will cover a larger area than 2048x2048 they will be split
# into several spritesheets.

# Depends on projmate-cli and pm-spritesheet both can be installed through npm.

ROOT=$1

TEXTURE_MAX=2048

# Get tile dimensions
FILE=`ls $ROOT | grep -m1 png`
FILE_DATA=`identify $ROOT/$FILE`
DIMENSTION=`echo $FILE_DATA | cut -d" " -f3`
WIDTH=`echo $DIMENSTION | cut -dx -f1`
HEIGHT=`echo $DIMENSTION | cut -dx -f2`
echo w: $WIDTH h: $HEIGHT
FRAMES=`ls $ROOT/*.png | wc -l`
echo $FRAMES Frames
W_FRAMES=`expr $TEXTURE_MAX / $WIDTH`
H_FRAMES=`expr $TEXTURE_MAX / $HEIGHT`
echo $W_FRAMES $H_FRAMES
PER_BATCH=`expr $W_FRAMES \* $H_FRAMES`
BATCHES=`echo $FRAMES / $PER_BATCH + 1 | bc`

echo $BATCHES of $PER_BATCH 

PM_TEMPLATE="exports.project = function(pm) {
  var f = pm.filters(require('pm-spritesheet'));
  return {
    spritesheet: {
      files: '*.png', 
      dev: [
        f.spritesheet({width: $TEXTURE_MAX, height: $TEXTURE_MAX, filename: 'FILENAME', root: 'ROOT/', jsonStyle:'texturePacker'})
      ]
    }
  };
};
"

OUT_FILE_BASE=`echo $FILE | cut -f1 -d"."`

for b in `seq 1 $BATCHES`; do
  echo $b
  T=`echo ${PM_TEMPLATE/ROOT/"../$b"}`
  T=`echo ${T/FILENAME/../"$OUT_FILE_BASE-$b.png"}`

  rm -rf $ROOT/$b
  mkdir $ROOT/$b
  echo $T > $ROOT/$b/Projfile.js
  for f in `ls $ROOT | grep -m$PER_BATCH png`; do
    mv $ROOT/$f $ROOT/$b/$f
  done

done

cd $ROOT
for b in `seq 1 $BATCHES`; do
  cd $b
  pm run spritesheet
  cd ..
done

exit 0
