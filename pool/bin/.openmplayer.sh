#!/bin/bash

mplayer=$(ps -ef | grep [m]player | awk '{print $8}' | head -n1)
if [ $mplayer != 'mplayer' ]; then
	nohup mplayer -playlist ~/Music/chiptune.pls & 
else
	pkill mplayer
fi
