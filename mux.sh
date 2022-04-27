#!/bin/bash

[[ -z "$(which mkvmerge)" ]] && echo "mkvtoolnix is not installed" && exit 1

#bash mux.sh EPISODE_NUMBER(INT)
echo "Starting..."
fonts_folder=$(cat table.json | jq ".fonts" | sed 's/"//gi')
arr_index=$(echo "$1-1" | bc )
episode=$(cat table.json | jq ".items[$arr_index]")
video=$(echo $episode | jq ".video"  | sed 's/"//gi')
subtitles=$(echo $episode | jq ".subtitles" | sed 's/"//gi')
title=$(cat table.json | jq ".title" | sed 's/"//gi')
prefix=$(cat table.json  | jq ".prefix"  | sed 's/"//gi')
resolution=$(cat table.json  | jq ".resolution"  | sed 's/"//gi')
episode_number=$(echo "$1" | bc )
episode_number=$(printf "%02d\n" $episode_number)

echo "Series title: $title"
echo "Episode: $episode_number"
echo "Resolution: $resolution"
echo "Prefix: $prefix"
echo "$video"
echo "Getting fonts..."

p=$(pwd)
for file in $fonts_folder/*; do
    f=$(basename "$file")
    fonts_string=$fonts_string" --attachment-mime-type application/x-truetype-font --attach-file \"./fonts/$f\""
    
done
#    fonts_string=$fonts_string" --attachment-mime-type application/x-truetype-font --attach-file "./$fonts_folder/$(basename $file)\""

#" --attachment-mime-type application/x-truetype-font --attach-file" \"./$fonts_folder/$(basename "$file")\"
#echo $fonts_string

#echo "Muxing to temp file..."
c="mkvmerge -o \"./mux/[$prefix] $title - $episode_number [$resolution].mkv\" --no-subtitles --no-attachments \"./video/$video\" --language 0:pl --track-name 0:Polish \"./subs/$subtitles\" $fonts_string"
eval $c

#[$prefix] $title - $numer_odcinka ($resolution) [CRC].mkv
