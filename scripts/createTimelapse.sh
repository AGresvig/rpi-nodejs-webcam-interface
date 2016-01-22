#!/bin/bash
CURRENT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

type avconv >/dev/null 2>&1 || { echo >&2 "I require 'avconv' but it's not installed.  Aborting."; exit 1; }

if [ "$#" -ne 3 ]
then
  echo "This script makes a timelapse video of filtered images in source folder"
  echo "Usage:"
  echo "Params:"
  echo "1: relative source dir of images"
  echo "2: max age of images to source in days (can be fractional, ie. .1)"
  echo "3: relative path of resulting video file"
  echo "Ex.: 'prepareStills.sh 'my/images' 2 my/video.mp4'"
  exit 1
fi

inputDir=$1
ageFilter=$2
outputFile=$3

test -d $inputDir || { echo "Directory $inputDir does not exist! Aborting."; exit 1;}

date +"%T Finding JPEGs no older than $ageFilter days in $inputDir"

# save and change IFS to allow for spaces in filenames
OLDIFS=$IFS
IFS=$'\n'

# Find files matching age, and sort them
declare -a files=( $(find $inputDir -name '*.jpg' -mtime -$ageFilter -type f -print | sort) )
# restore IFS
IFS=$OLDIFS

# Check that files were actually found
if test -z "$files"; then echo "No jpeg files matching age requirement found in $inputDir. Aborting."; exit 1; fi

date +"%T Making timelapse from ${#files[@]} images"

# Create temp dir (delete if exists)
cd $CURRENT_DIR
test -f 'temp' || rm -rf 'temp'
mkdir 'temp'

counter=0

# Copy files to temp location
for file in "${files[@]}"; do
  # Copy files named as incrementing number padded with zeroes (6 digits)
  newFilename="img_$(printf "%0*d\n" 6 $counter).jpg"
  cp "$file" "temp/$newFilename"
  ((counter++))
done
start=`date +%s`
# Run avconv to create video using a series of stills specified. Ouput to $outputFile
# -v 'warning': loglevel warning
# -y: force overwrite
# -f image2: input format is sequence of images
# -r 15: show every still for 1/5th of a second
# -r 24: resulting videoo should have 24 fps
# -preset slower -crf 27: Use 'slower' preset with crf value 27 for better compression
avconv -v 'warning' -y \
  -f image2  \
  -r 5 \
  -i 'temp/img_%06d.jpg' \
  -r 24 \
  $outputFile
end=`date +%s`

# Delete temp files
rm -rf 'temp'

date +"%T Video '$outputFile' created in $((end-start)) seconds"
