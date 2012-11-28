#!/bin/bash -x

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

	if [ -e "$HOME/$fic" ] ; then
		cp "$HOME/$fic" "$fic"
	fi

	git add "$fic"
}

function link_conf {
	fic="$1"
	echo rm "$HOME/$fic"
	rep="$(dirname "$fichier")"
	if [ ! -d "$HOME/$rep" ] ; then
		echo mkdir -p $HOME/"$rep"
	fi
	if [ ! -d $rep ] ; then
		echo ln -sf "$HOME/$fic" "$fic"
	fi
}

# backup
if ! branch_exists "$(hostname)"; then
	git checkout -b "$(hostname)" 
else
	git checkout "$(hostname)"
fi

for_all_conffiles backup

git commit -am "Backup commit : $(date)"

# install new files
git checkout master
for_all_conffiles link_conf

