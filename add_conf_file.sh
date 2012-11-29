#! /bin/bash

name="$0"
rep=$(dirname $0)

. "$rep/functions"


# must be used in home directory 
cd $rep/files

for fichier in $@ ; do
	if [ -d "$HOME/$fichier" ] ; then
		find $fichier
	elif [ -e "$fichier" ] ; then
		echo "$fichier"
	fi
done | for_all_input_files backup

