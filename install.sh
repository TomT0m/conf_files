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

function for_all_input_files() {
	command=$1
	pushd .
	cd files/
	while read fichier ; do
		$command "$fichier"
	done
	popd .
}

function backup() {
	local fic="$1"

	if [ -d "$HOME/$fic" -a -e "$HOME/$fic" ] ; then 
		mkdir -p "$HOME/$fic"
	elif [ -e "$HOME/$fic" ] ; then
		mkdir -p "$(dirname "$fic")"
		cp "$HOME/$fic" "$fic"
	fi

	git add "$fic"
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

cd files
new_conf_files="$( git ls-files )"
cd ..

# backup
if ! branch_exists "$(hostname)"; then
	git checkout -b "$(hostname)" 
else
	git checkout "$(hostname)"
fi

# copy current version of old backups file list
cd files/
git ls-files | while read old_file ; do
	if [ -e "$HOME/$old_file" ] ; then 
		cp "$HOME/$old_file" "$old_file" ; 
		git add "$old_file" ; 
	else
		git rm "$old_file"
	fi
done
cd ..

#copy current version of new file list

echo -n "$new_conf_files" | for_all_input_files backup


git checkout master install.sh
git commit -am "Backup commit : $(date)"

# install new files
git checkout master

git submodule init
git submodule update

for_all_conffiles link_conf

