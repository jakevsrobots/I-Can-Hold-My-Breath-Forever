#!/bin/sh

python src/compile_levels.py
mxmlc src/breath/Main.as -source-path=src/ -output output/ICanHoldMyBreathForever.swf && flashplayer_10 output/ICanHoldMyBreathForever.swf