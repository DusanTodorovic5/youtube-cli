#!/bin/bash

echo -n "Checking dependencies... "
for name in youtube-dl
do
  [[ $(which $name 2>/dev/null) ]] || { echo -en "\n$name needs to be installed. Use 'sudo pacman -S $name'";deps=1; }
done
[[ $deps -ne 1 ]] && echo "OK" || { echo -en "\nInstall the above and rerun this script\n";exit 1; }

if [ $# -eq 0 ]
  then
    echo "No arguments supplied. Please specify the location of links to download"
	echo "The links should be given in file as example on github page:"
	echo "https://github.com/DusanTodorovic5/youtube-cli/blob/main/files_to_download"
  exit 1;
fi

if [[ ! -f $1 ]]
then
    echo "$1 does not exist on your filesystem."
fi

mkdir -p mp3
cd mp3

input=
case $input in
  /*) input=$1 ;;
  *) input="../${1}" ;;
esac

while IFS= read -r line
do
	echo "$line"
	youtube-dl -o "%(title)s.%(ext)s" --extract-audio --audio-format mp3 $line
done < "$input"
