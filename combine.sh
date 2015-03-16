#!/bin/sh

convert \
	converted/test-right.jpg \
	converted/test-left.jpg \
	+append converted/test-a.jpg

convert \
	\( converted/test-right.jpg -crop '+0-9' \) \
	\( converted/test-left.jpg  -crop '+0+9' \) \
	+append converted/test-b.jpg
