#! /bin/bash 

#Description: A script converting a .dot graphviz file into a svg file

#Dependancies: dot2tex, pdflatex, inkscape

base="$1/$2"

(
set -x 

if [ -f "$base.dot" ] ; then 
	cd $1	
	dot2tex "$base.dot" --crop > "$base.tex" 

	pdflatex "$base.tex" 
	inkscape -z "$base.pdf" --export-plain-svg="$base.svg" --export-width=300
	
	rm "$base".{log,tex,aux}
fi ) > /tmp/log.tmp
