#! /bin/bash 

name="$0"
rep="$(dirname $0)"

. "$rep/functions"


# must be used in home directory 
cd $rep

list="$(for fichier in $@ ; do
	if [ -d "$HOME/$fichier" ] ; then
		find $fichier
	elif [ -e "$HOME/$fichier" ] ; then
		echo "$fichier"
	fi
done)"
echo $list | for_all_input_files backup



git commit -m "$date : \n added files to config : \n $list"
git push

