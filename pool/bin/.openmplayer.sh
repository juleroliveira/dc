#!/bin/bash

ls -lrht $HOME/Music/*.pls | awk '{print $9}' > $HOME/Music/playlist ; echo "" >> $HOME/Music/playlist
playlist="$HOME/Music/playlist"
act=$(cat $HOME/Music/act)
cnt=0

mplayer=$(ps -ef | grep [m]player | awk '{print $8}' | head -n1)
    
while IFS= read -r linha || [[ -n "$linha" ]]; do

	if [ -z "$linha" ];then
		ls -lrht $HOME/Music/*.pls | awk '{print $9}' | head -n1 > $HOME/Music/act
	fi
	
	if [[ "$cnt" = 1 ]];then
	
		if [ "$mplayer" != "mplayer" ]; then
			#nohup mplayer -ao alsa:device=hw=0.0 -playlist $linha &
			nohup mplayer -playlist $linha &
			echo $linha > $HOME/Music/act
		else
			pkill mplayer
		fi
    
    break
    
  fi
  
  if [ "$linha" = "$act" ];then
    cnt=$(( $cnt + 1 ))
  fi

done < "$playlist"
