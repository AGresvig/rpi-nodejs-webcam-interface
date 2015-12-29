#!/bin/bash

# Check utils exist
type raspistill >/dev/null 2>&1 || { echo >&2 "I require 'raspistill' but it's not installed.  Aborting."; exit 1; }
type mogrify >/dev/null 2>&1 || { echo >&2 "I require 'mogrify' (part of 'imagemagick') but it's not installed.  Aborting."; exit 1; }

if [ "$#" -lt 1 ]
then
  echo "This script snaps a still shot and timestamps it in lower left corner"
  echo "Required params: output-dir"
  echo "Optional params: width, height, quality - defaults to 1920x1080 @ 80%"
  echo "Usage:"
  echo "snapshot.sh 'my/stills/*.jpg' 2500 1200 100"
  exit 1
fi

width=${2-1920}
height=${3-1080}
quality=${4-80}

date +"%T Snapping picture with dimensions $width x $height, quality $quality"
if test -d $1; then
  outdir=$1
else
  date +"%T Directory $1 does not exist! Aborting"
  exit 1
fi

timestamp=$(date +"%m-%d-%y %T")
filename="$outdir/$timestamp.jpg"


# snap pic
raspistill -w $width -h $height -q $quality -o "$filename"
date +"%T Saved image to $filename"
# datestamp it
mogrify -pointsize 20 -fill red -draw "text 0, $height '$(date)'" "$filename"
date +"%T Image timestamped"
