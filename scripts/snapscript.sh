#!/bin/bash


if [ "$#" -lt 1 ]
then
  echo "This script snaps a still shot and timestamps it"
  echo "Required arg: -o output-dir"
  echo "Optional args: -w width, -h height, -q quality, -u camera-utility"
  echo "Defaults to 1920x1080 @ 80% using 'raspistill'"
  echo "Possible camera-utils: raspistill, fswebcam, imagesnap"
  echo "Example usage:"
  echo "snapshot.sh -w 2500 -h 1200 -q 100 -u fswebcam -o '~/my/stills/'"
  echo "Results in '~/my/stills/<MM-DD-YY HH:MM:SS>.jpeg'"
  exit 1
fi

# Parse args
while getopts w:h:q:u:o: option
do
  case "${option}" in
    w) W=${OPTARG};;
    h) H=${OPTARG};;
    q) Q=${OPTARG};;
    u) U=${OPTARG};;
    o) O=${OPTARG};;
  esac
done

# Add default values
width=${W-1920}
height=${H-1080}
quality=${Q-80}
utility=${U-raspistill}
outdir=${O}

#echo "Parsed input: dimensions $width x $height, quality $quality, utility $utility, output-dir $outdir"

# Check output dir
test ! -z $outdir || { echo "Output directory not specified! Aborting."; exit 1;}
test -d $outdir || { echo "Directory '$outdir' does not exist! Aborting."; exit 1;}

# Check utils exist
[[ 'raspistill fswebcam imagesnap' =~ $utility ]] || { echo "Unsupported utility: '$utility'. Aborting."; exit 1;}
type $utility >/dev/null 2>&1 || { echo >&2 "I require '$utility' but it's not installed.  Aborting."; exit 1; }

date +"%T Snapping picture using $utility, dimensions $width x $height, quality $quality"

timestamp=$(date +"%m-%d-%y %T")
filename="$outdir/$timestamp.jpg"

date +"%T Saving to $filename"

# snap pic
case $utility in
"raspistill")
    raspistill -w $width -h $height -q $quality -o "$filename"
    ;;
"fswebcam")
    fswebcam -r "$width"x"$height" --jpeg $quality "$filename"
    ;;
"imagesnap")
    imagesnap "$filename"
    ;;
esac

# datestamp if needed (fswebcam datestamps itself)
case $utility in
"raspistill" | "imagesnap")
    # imagemagick (mogrify) & ghostscript required to do image-stamping here
    type mogrify >/dev/null 2>&1 || { echo >&2 "I require 'mogrify' (part of 'imagemagick') but it's not installed.  Aborting."; exit 1; }
    type gs >/dev/null 2>&1 || { echo >&2 "I require 'gs' (part of 'ghostscript') but it's not installed.  Aborting."; exit 1; }    # imagemagick (mogrify) & ghostscript required to do image-stamping here
    # datestamp it
    mogrify -pointsize 20 -fill red -draw "text 0, $height '$(date)'" "$filename"
    date +"%T Image timestamped"
    ;;
esac

date +"%T Saved image to $filename"
