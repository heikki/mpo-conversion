#!/bin/bash

rm converted/**/* 2&>/dev/null

[ "$#" -gt 0 ] || set -- mpo/*.MPO

for FILE in $@
do

	# OUTPUT=`basename -s '.MPO' $FILE`.jpg
	OUTPUT=`exiftool -CreateDate -d "%Y-%m-%dT%H-%M-%S" -S -t $FILE`.jpg

	echo `basename $FILE` -\> $OUTPUT

	LEFT=converted/left/$OUTPUT
	RIGHT=converted/right/$OUTPUT

	exiftool -trailer:all= $FILE -o $LEFT > /dev/null
	exiftool $FILE -mpimage2 -b > $RIGHT

	convert $RIGHT $LEFT +append converted/right-left/$OUTPUT

done
