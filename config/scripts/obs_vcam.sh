#!/bin/bash

echo Removing module in case it is there and you need a new version ..
sudo rmmod -v -f v4l2loopback
echo Loading v4l2loopback module with needed params ...
sudo insmod ~/src/v4l2loopback/v4l2loopback.ko video_nr=11,12 max_buffers=2 exclusive_caps=1 card_label=vcam_OBS,vcam_Effects
echo Loaded.
ls /dev/video*
