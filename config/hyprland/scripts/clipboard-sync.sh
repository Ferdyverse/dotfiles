#!/bin/bash

while true; do
    clip=$(wl-paste) && echo -n "$clip" | xclip -selection clipboard
    sleep 0.1
done
