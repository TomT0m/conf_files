#! /bin/bash

#Description : moves conf files current version into repo

name="$0"
rep="$(dirname $0)"

. "$rep/functions"

cd $rep

for_all_conffiles backup

