#!/bin/bash 

#Description : backup & installs repos files into main directory


base="$(dirname $0)"
cd $base

source functions

function branch_exists(){
	git show-ref --verify --quiet "refs/heads/$1"
	return $?
}




function link_conf {
	fic="$1"
	echo "treating $1 ..."
	# rm "$HOME/$fic"
	rep="$(dirname "$fichier")"
	if [ ! -d "$HOME/$rep" ] ; then
		mkdir -p $HOME/"$rep"
	fi
	if [ -f "$fic" ]; then
		cp "$fic" "$HOME/$fic"
	fi
}

# getting filename that will be erased
cd files
new_conf_files="$( git ls-files )"
cd ..



backup_branch="$(hostname)-$(whoami)"
if ! branch_exists "$backup_branch"; then
	git checkout -b "$backup_branch" 
else
	git checkout "$backup_branch"
fi

# copy current version of old backups file list
git ls-files | for_all_input_files backup

# copy current version of new file list
echo -n "$new_conf_files" | for_all_input_files backup


##### init conf #####
git checkout master install.sh
git commit -am "Backup commit : $(date)"

git checkout master

git submodule init
git submodule update


# install new files
for_all_conffiles link_conf

