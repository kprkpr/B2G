#!/bin/sh
if [ -d sourcefix ]
then
	echo Patching source tree...
	cp -Rp sourcefix/* ./
else
	echo No patches were downloaded
fi
