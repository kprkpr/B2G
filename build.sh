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

. build/envsetup.sh
lunch $LUNCH
make -j6 otapackage
if [ -e out/target/product/$DEVICE/full_$(echo $DEVICE)-ota-eng.$(whoami).zip ]
then
	mkdir release
	mv out/target/product/$DEVICE/full_$(echo $DEVICE)-ota-eng.$(whoami).zip release/ffos-$(echo $DEVICE)-$(whoami)-$(date +%y%m%d).zip
	echo Build successful. Find .zip in release/
else
	echo Something went wrong. Try building manually with -j1 to get human-readable messages.
fi
