#!/bin/sh
if [ -d sourcefix ]
then
	echo Patching source tree...
	cd sourcefix
	FILELIST=$(find .)
	for FILETOPATCH in $FILELIST;
	do
		if [ -e ../$FILETOPATCH ]
		then
			echo Patching $FILETOPATCH
			cp $FILETOPATCH ../$FILETOPATCH
		else
			echo $FILETOPATCH does not exist
		fi
	done
else
	echo No patches were downloaded
fi
