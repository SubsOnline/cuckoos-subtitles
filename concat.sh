#!/bin/bash

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

echo "$subtitles"

clear_line="Dialogue: 0,0:00:00.00,0:00:00.00,Main,Nagi/Erika,0,0,0,,{TS}"
delimeter="Format: Layer, Start, End, Style, Name, MarginL, MarginR, MarginV, Effect, Text"

# split file by delimeter and save to seperate file
csplit -f ./temp/TMP_${episode_number}_ --suppress-matched "./ts/${subtitles}"  "/^$delimeter/" {*}

savefile="./subs/$subtitles"

cat "./korekta/${subtitles}" > "${savefile}" 
echo "Dialogue: 0,0:00:00.00,0:00:00.00,Main,Nagi/Erika,0,0,0,,{OP}" >> "${savefile}"
cat "./op/${subtitles}" | tr -d '﻿' >> "${savefile}" 
echo "Dialogue: 0,0:00:00.00,0:00:00.00,Main,Nagi/Erika,0,0,0,,{OP}" >> "${savefile}"
echo "Dialogue: 0,0:00:00.00,0:00:00.00,Main,Nagi/Erika,0,0,0,,{TS}" >> "${savefile}"
cat "./temp/TMP_${episode_number}_01"  >> "${savefile}"
echo "Dialogue: 0,0:00:00.00,0:00:00.00,Main,Nagi/Erika,0,0,0,,{TS}" >> "${savefile}"

rm -rf ./temp/TMP_${episode_number}_*

bash ./mux.sh $1