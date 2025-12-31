#!/bin/bash
# new videos can be pulled here: https://docs.google.com/spreadsheets/d/1bboTohF06r-fafrImTExAPqM9m6h2m2lgJyAkQuYVJI/edit?gid=1684411812#gid=1684411812

set -euo pipefail
export DISPLAY=:0

FOLDER="/home/pi/videos/scenes"
#matching for mov and mp4
PATTERN="*.m*"

# vlc --loop --fullscreen --no-video-title-show ./path

#find and shuffle scenes - force square aspect ratio for the portal size (omitting may result in letterboxing)
find "$FOLDER" -maxdepth 1 -type f -name "$PATTERN" | shuf | xargs -r vlc --fullscreen --loop --no-video-title-show --aspect-ratio=16:16
