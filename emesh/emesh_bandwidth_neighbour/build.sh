#!/bin/bash

set -e

ESDK=${EPIPHANY_HOME}
ELIBS="-L ${ESDK}/tools/host/lib"
EINCS="-I ${ESDK}/tools/host/include"
ELDF=${ESDK}/bsps/current/internal.ldf

SCRIPT=$(readlink -f "$0")
EXEPATH=$(dirname "$SCRIPT")
cd $EXEPATH

# Create the binaries directory
mkdir -p bin/

if [ -z "${CROSS_COMPILE+xxx}" ]; then
case $(uname -p) in
	arm*)
		# Use native arm compiler (no cross prefix)
		CROSS_COMPILE=
		;;
	   *)
		# Use cross compiler
		CROSS_COMPILE="arm-linux-gnueabihf-"
		;;
esac
fi

# Build HOST side application
${CROSS_COMPILE}gcc src/mesh_bandwidth.c -o bin/mesh_bandwidth.elf ${EINCS} ${ELIBS} -le-hal -le-loader -lpthread


# Build DEVICE side program
e-gcc -O3 -T ${ELDF} src/e_mesh_bandwidth_near.c -o bin/e_mesh_bandwidth_near.elf -le-lib 





e-objcopy --srec-forceS3 --output-target srec bin/e_mesh_bandwidth_near.elf bin/e_mesh_bandwidth_near.srec
