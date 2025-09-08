#!/usr/bin/env bash

mkdir transcoded

for i in *.MP4; do
    #ffmpeg -i "$i" -vcodec mjpeg -q:v 2 -acodec pcm_s16be -q:a 0 -f mov "transcoded/${i%.*}.mov"
    ffmpeg -i "$i" -c:v dnxhd -profile:v dnxhr_hq -pix_fmt yuv422p -c:a alac "transcoded/${i%.*}.mov"
done
