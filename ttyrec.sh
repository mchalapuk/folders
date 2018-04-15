#!/bin/sh
#
# This script contains all commands typed when recording a demo with ttystudio.
#
# Copyright (c) Maciej Chałapuk
# Released under MIT License

cd ~/bin
ls
wget https://raw.githubusercontent.com/mchalapuk/folders/master/folders.s://raw.githubusercontent.com/mchalapuk/folders/master/folders.sh -O folders
chmod +x folders
folders ?

ln -s folders repos

cd ~/code
repos list
repos add *
repos list

repos run git status
repos run git checkout master
repos run git branch -u origin/master master
repos run git pull
repos -c run git push

