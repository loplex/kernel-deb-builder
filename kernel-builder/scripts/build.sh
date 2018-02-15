#!/bin/bash
set -x
set -e

# if MAKEFLAGS not set, USE '-j<NUMBER_OF_PROCESSORS*2>'
: "${MAKEFLAGS:=-j$(($(nproc)*2))}"

# extract the kernel source code
cd /build/linux
dpkg-source -x ./*.dsc

# go to linux kernel source directory (name depends on version)
cd -P /build/linux/linux-*

# add custom patches (if any) and generate corresponding changelog entry
if [ -e /build/patches/* ]; then
	echo -e "\n# Custom patches:" >>./debian/patches/series

	quilt import /build/patches/*

	# create changelog entry from patches descriptions
	dep3changelog "$(quilt unapplied)" -- $DEBCHANGE_OPTIONS

	# apply custom patches
	quilt push -a
else
	debchange $DEBCHANGE_OPTIONS 'Build with unchanged sources'
fi

# build
make -f debian/rules.gen setup_${ARCH}_${FEATURESET}_${FLAVOUR}
make -f debian/rules.gen binary-arch_${ARCH}_${FEATURESET}_${FLAVOUR} binary-indep_${FEATURESET}

# move output deb packeges to /build/out directory
mkdir /build/out
mv /build/linux/*.deb  /build/out/

