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
make -j4
echo If build was unsuccessful, try building with the "m" command to get a user-friendly output.
