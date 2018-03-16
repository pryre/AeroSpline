#!/bin/sh

BUILD_TYPE="Debug"

#Check to see if the compile directory exists
mkdir -p aerospline-bin

pushd ./aerospline-bin
cmake ../aerospline -DCMAKE_MODULE_PATH=/usr/lib/OGRE/cmake -DCMAKE_BUILD_TYPE="$BUILD_TYPE"
make
popd

if [ $# -ne 0 ];
then
	case $1 in
		run)
			./aerospline-bin/bin/aerospline
			break
			;;
		*)
			echo "command \"$1\" is unsupported"
			;;
	esac
fi
