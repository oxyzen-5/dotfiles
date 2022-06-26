#!/bin/bash
cp ~/.zshrc ~/dotfiles
echo “Copied zshrc”

cp ~/.config/nvim/init.vim ~/dotfiles
echo “Copied zshrc”

echo “All Files copied.”

#git_location=~/dotfiles/
working_location=$(pwd)

pushd /home/oxyzen/dotfiles
ls
echo $(pwd)

git add .

date
date +"%FORMAT"
var=$(date)
var=`date`
echo "$var"

git commit -m "$var"

git push origin master
