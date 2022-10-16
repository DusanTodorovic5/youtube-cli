#!/bin/bash

# Giving user information what we will do
echo -n "Checking dependencies... "
# Checking dependency for youtube-dl and ffmpeg
for name in youtube-dl ffmpeg
do
  # If user does not any of these 2 programs, which will return error, and we will set flag deps to 1
  [[ $(which $name 2>/dev/null) ]] || { echo -en "\n$name needs to be installed. Use 'sudo pacman -S $name' ";deps=1; }
done
# When we check all dependencies, if deps was set on 1, we will inform user of needed dependency and exit the script
[[ $deps -ne 1 ]] && echo "OK" || { echo -en "\nInstall the above and rerun this script\n";exit 1; }

# We check if there are arguments given, $# is number of arguments
if [ $# -eq 0 ]
  then
    echo "No arguments supplied. Please specify the location of links to download"
	  echo "The links should be given in file as example on github page:"
	  echo "https://github.com/DusanTodorovic5/youtube-cli/blob/main/files_to_download"
    exit 1;
fi
# We check if the first argument is file, if not, we exit program
if [[ ! -f $1 ]]
then
    echo "$1 does not exist on your filesystem."
    exit 2
fi
# We create directory /mp3, -p flag means that it will be created only if it doesn't exist
mkdir -p mp3
# We changed current working directory to mp3
cd mp3
# Create empty variable input, we will store path to file there
input=
# Check if file path is absolute or relative
case $1 in
  /*) input=$1 ;;
  *) input="../${1}" ;; # If it is relative, it doesn't start with '/' which means we should add '../' to it, because user called it from directory before 'mp3'
esac
# Now we read each line of file given as argument
while IFS= read -r line
do
	echo "$line"
	youtube-dl -o "%(title)s.%(ext)s" --extract-audio --audio-format mp3 $line
done < "$input"
