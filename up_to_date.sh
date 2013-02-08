# !/bin/bash

#Description: Checks if repo and installed files are in line

cd "$(dirname $0)"

source functions

cd files/

function up_to_date () {
	if ! cmp "$1" "$HOME/$1" &> /dev/null ; then
		echo $1
	fi
}

diff=0

for_all_conffiles up_to_date | while read fic; do
	echo Différents : $fic
done
