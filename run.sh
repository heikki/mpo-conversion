#!/bin/bash

rm converted/**/* 2&>/dev/null

FILES=mpo/*.MPO

for FILE in $FILES
do

	OUTPUT=`basename -s '.MPO' $FILE`.jpg

	LEFT=converted/left/$OUTPUT
	RIGHT=converted/right/$OUTPUT

	exiftool -trailer:all= $FILE -o $LEFT
	exiftool $FILE -mpimage2 -b > $RIGHT

	convert $RIGHT $LEFT +append converted/right-left/$OUTPUT

done
