#!/bin/bash

REPO=${REPO:-./repo}
sync_flags=""

repo_sync() {
	rm -rf .repo/manifest* &&
	$REPO init -u $GITREPO -b $BRANCH -m $1.xml &&
	$REPO sync $sync_flags
	ret=$?
	if [ "$GITREPO" = "$GIT_TEMP_REPO" ]; then
		rm -rf $GIT_TEMP_REPO
	fi
	if [ $ret -ne 0 ]; then
		echo Repo sync failed
		exit -1
	fi
}

case `uname` in
"Darwin")
	# Should also work on other BSDs
	CORE_COUNT=`sysctl -n hw.ncpu`
	;;
"Linux")
	CORE_COUNT=`grep processor /proc/cpuinfo | wc -l`
	;;
*)
	echo Unsupported platform: `uname`
	exit -1
esac

GITREPO=${GITREPO:-"git://github.com/feherneoh/repo-manifests"}
BRANCH=${BRANCH:-ffos}

while [ $# -ge 1 ]; do
	case $1 in
	-d|-l|-f|-n|-c|-q)
		sync_flags="$sync_flags $1"
		shift
		;;
	--help|-h)
		# The main case statement will give a usage message.
		break
		;;
	-*)
		echo "$0: unrecognized option $1" >&2
		exit 1
		;;
	*)
		break
		;;
	esac
done

GIT_TEMP_REPO="tmp_manifest_repo"
if [ -n "$2" ]; then
	GITREPO=$GIT_TEMP_REPO
	rm -rf $GITREPO &&
	git init $GITREPO &&
	cp $2 $GITREPO/$1.xml &&
	cd $GITREPO &&
	git add $1.xml &&
	git commit -m "manifest" &&
	git branch -m $BRANCH &&
	cd ..
fi

echo MAKE_FLAGS=-j$((CORE_COUNT + 2)) > .tmp-config
echo GECKO_OBJDIR=$PWD/objdir-gecko >> .tmp-config
echo DEVICE_NAME=$1 >> .tmp-config

case "$1" in
"anzu")
	echo DEVICE=anzu >> .tmp-config &&
	echo LUNCH=full_anzu-eng >> .tmp-config &&
	repo_sync $1
	;;
"coconut")
	echo DEVICE=coconut >> .tmp-config &&
	echo LUNCH=full_coconut-eng >> .tmp-config &&
	repo_sync $1
	;;
"es209ra")
	echo DEVICE=es209ra >> .tmp-config &&
	echo LUNCH=es209ra-eng >> .tmp-config &&
	repo_sync $1
	;;
"haida")
	echo DEVICE=haida >> .tmp-config &&
	echo LUNCH=full_haida-eng >> .tmp-config &&
	repo_sync $1
	;;
"hallon")
	echo DEVICE=hallon >> .tmp-config &&
	echo LUNCH=full_hallon-eng >> .tmp-config &&
	repo_sync $1
	;;
"iyokan")
	echo DEVICE=iyokan >> .tmp-config &&
	echo LUNCH=full_iyokan-eng >> .tmp-config &&
	repo_sync $1
	;;
"kumquat")
	echo DEVICE=kumquat >> .tmp-config &&
	echo LUNCH=full_kumquat-eng >> .tmp-config &&
	repo_sync $1
	;;
"lotus")
	echo DEVICE=lotus >> .tmp-config &&
	echo LUNCH=full_lotus-eng >> .tmp-config &&
	repo_sync $1
	;;
"mango")
	echo DEVICE=mango >> .tmp-config &&
	echo LUNCH=full_mango-eng >> .tmp-config &&
	repo_sync $1
	;;
"nypon")
	echo DEVICE=nypon >> .tmp-config &&
	echo LUNCH=full_nypon-eng >> .tmp-config &&
	repo_sync $1
	;;
"pepper")
	echo DEVICE=pepper >> .tmp-config &&
	echo LUNCH=full_pepper-eng >> .tmp-config &&
	repo_sync $1
	;;
"satsuma")
	echo DEVICE=satsuma >> .tmp-config &&
	echo LUNCH=full_satsuma-eng >> .tmp-config &&
	repo_sync $1
	;;
"smultron")
	echo DEVICE=smultron >> .tmp-config &&
	echo LUNCH=full_smultron-eng >> .tmp-config &&
	repo_sync $1
	;;
"urushi")
	echo DEVICE=urushi >> .tmp-config &&
	echo LUNCH=full_urushi-eng >> .tmp-config &&
	repo_sync $1
	;;
"zeus")
	echo DEVICE=zeus >> .tmp-config &&
	echo LUNCH=full_zeus-eng >> .tmp-config &&
	repo_sync $1
	;;
"zeusc")
	echo DEVICE=zeusc >> .tmp-config &&
	echo LUNCH=full_zeusc-eng >> .tmp-config &&
	repo_sync $1
	;;

*)
	echo "Usage: $0 [-cdflnq] (device name)"
	echo "Flags are passed through to |./repo sync|."
	echo
	echo Valid devices to configure are:
	echo (Sony Ericsson)
	echo - anzu
	echo - coconut
	echo - es209ra
	echo - haida
	echo - hallon
	echo - iyokan
	echo - mango
	echo - satsuma
	echo - smultron
	echo - urushi
	echo - zeus
	echo - zeusc
	echo (Sony)
	echo - kumquat
	echo - lotus
	echo - nypon
	echo - pepper
	exit -1
	;;
esac

if [ $? -ne 0 ]; then
	echo Configuration failed
	exit -1
fi

mv .tmp-config .config
./patch.sh
echo Run \|./build.sh\| to start building
