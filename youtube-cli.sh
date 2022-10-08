#!/bin/bash

# Ispis
echo -n "Checking dependencies... "
# proveravamo dependency za youtube-dl
for name in youtube-dl ffmpeg
do
  # Proveravamo postoji li, ako ne postoji, upisemo u neki flag 'deps' 1
  [[ $(which $name 2>/dev/null) ]] || { echo -en "\n$name needs to be installed. Use 'sudo pacman -S $name' ";deps=1; }
done
# Kad proverimo sve, vidimo ako ima flag 'deps' na 1, onda trebamo da iskljucimo skriptu
[[ $deps -ne 1 ]] && echo "OK" || { echo -en "\nInstall the above and rerun this script\n";exit 1; }

# Proverimo broj argumenata, '$#' predstavlja broj argumenata, ako je nula, ispisemo poruku i izadjemo
if [ $# -eq 0 ]
  then
    echo "No arguments supplied. Please specify the location of links to download"
	  echo "The links should be given in file as example on github page:"
	  echo "https://github.com/DusanTodorovic5/youtube-cli/blob/main/files_to_download"
    exit 1;
fi
# Proverimo da li je prvi argument fajl, ako nije, ispisemo poruku i izadjemo
if [[ ! -f $1 ]]
then
    echo "$1 does not exist on your filesystem."
    exit 2
fi
# Napravimo folder mp3 ako ne postoji. '-p' argument znaci da ako postoji folder, ne radimo nista
mkdir -p mp3
# Promenimo direktorijum na mp3
cd mp3
# Napravimo praznu promenjivu input. 
input=
# Proverimo da li je prvi argument apsolutna putanja do fajl, ili relativna
# Apsolutna putanja pocinje kosom crtom, relativna bilo cime 
case $1 in
  /*) input=$1 ;;
  *) input="../${1}" ;; # Ako je relativna putanja, dodamo '../'. Vratimo se u prosli direktorijum a ne mp3, jer je relativno u odnosu na mesto skripte
esac
# Sada procitamo svaku liniju u datom fajlu
while IFS= read -r line
do
  # Ispisem link
	echo "$line"
  # Zovemo program 'youtube-dl' sa argumentima
  # '-o' predstavlja ime fajla, stavimo title i ext, title je ime video snimka, ext je extenzija
  # Stavimo i argument --extract-audio da izvuce samo zvuk, a ne ceo video
  # Dodamo i argument --audio-format mp3 kako bi to sacuvao u mp3 formatu(odma konvertuje sa ffmpeg)
	youtube-dl -o "%(title)s.%(ext)s" --extract-audio --audio-format mp3 $line
done < "$input"
