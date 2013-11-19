#!/bin/bash
# Firefox OS build script
if [[ ! -n "$B2G_DIR" ]]; then
  B2G_DIR=$(cd `dirname $0`; pwd)
fi

. "$B2G_DIR/.config"
if [ $? -ne 0 ]; then
	echo Could not load .config. Did you run config.sh?
	exit -1
fi
. "$B2G_DIR/.b2gversion"
DEFAULTZIP=full_$(echo $DEVICE)-ota-eng.$(whoami).zip
BUILTZIP=${DEVICEZIP-$DEFAULTZIP}
ZIPPATH=$B2G_DIR/out/target/product/$DEVICE
RELEASEZIP=ffos$(echo $B2GVER)-$(echo $DEVICE)-$(whoami)-$(date +%y%m%d).zip
. build/envsetup.sh
lunch $LUNCH
make -j6 otapackage
if [ -e $ZIPPATH/$BUILTZIP ]
then
	mkdir release
	mv $ZIPPATH/$BUILTZIP release/$RELEASEZIP
	echo Build successful. Find .zip in release/
else
	echo Something went wrong. Try building manually with -j1 to get human-readable messages.
fi
