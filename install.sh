#!/bin/bash

cd "$(dirname $0)"

origin=$(pwd)

host="$(hostname)"

function inst_file()

function backup_files()


function branch_exists(){
	git show-ref --verify --quiet "refs/heads/$1"
}


function for_all_conffiles() {
	command=$1
	for fichier in $(find) ; do 
		rep = $(dirname $x)
		if [ ! -d "$rep" ] ;
			mkdir -p $rep
		fi

		$command "$1"
	done

}

function backup() {
	local fic="$1"

	if [ ! -e "$fic" ] ; do
		cp "$HOME/$fic" "$fic"
	done
	git add "$fic"
}

function link_conf {
	echo rm "$HOME/$fic"
	echo ln "$HOME/$fic" "$fic"
}

# backup
if ! branch_exists '$(hostname)'; then
	git checkout -b "$(hostname)" 
else
	git checkout $(hostname)
fi

for_all_conffiles add_repo

git commit -c "Backup commit : $date"

git checkout master
for_all_conffiles link_conf

