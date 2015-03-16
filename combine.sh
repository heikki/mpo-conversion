#!/bin/sh

convert \
	'converted/test-right.jpg' \
	'converted/test-left.jpg' \
	+append \
	converted/test-a.jpg

convert \
	'converted/test-right.jpg' \
	'converted/test-left.jpg[+0+9]' \
	+append \
	-crop '+0-9' \
	converted/test-b.jpg
