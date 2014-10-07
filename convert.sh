#!/bin/bash

rm converted/**/* 2&>/dev/null

[ "$#" -gt 0 ] || set -- mpo/*.MPO

for FILE in $@
do

	OUTPUT=`basename -s '.MPO' $FILE | tr "[:upper:]" "[:lower:]"`
	# OUTPUT=`exiftool -CreateDate -d "%Y-%m-%dT%H-%M-%S" -S -t $FILE`.jpg

	echo `basename $FILE` -\> $OUTPUT.jpg

	LEFT=converted/separate/$OUTPUT-left.jpg
	RIGHT=converted/separate/$OUTPUT-right.jpg

	exiftool -trailer:all= $FILE -o $LEFT > /dev/null
	exiftool $FILE -mpimage2 -b > $RIGHT

	convert $RIGHT $LEFT +append converted/cross-eye/$OUTPUT.jpg

done
