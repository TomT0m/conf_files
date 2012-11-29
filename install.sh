#!/bin/bash 

cd "$(dirname $0)"

origin="$(pwd)"
host="$(hostname)"

function branch_exists(){
	git show-ref --verify --quiet "refs/heads/$1"
	return $?
}


function for_all_conffiles() {
	command=$1
	pushd .
	cd files/
	for fichier in $(find) ; do 
		$command "$fichier"
	done
	popd
}

function backup() {
	local fic="$1"

	if [ -d "$HOME/$fic" -a -e "$HOME/$fic" ] ; then 
		mkdir -p "$HOME/$fic"
	elif [ -e "$HOME/$fic" ] ; then
		mkdir -p "$(dirname "$fic")"
		cp "$HOME/$fic" "$fic"
		git add "$fic"
	fi
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



backup_branch="$(hostname)-$(username)"
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

