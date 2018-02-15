#!/bin/bash
set -x
set -e

date '+%F %T' #date

# if MAKEFLAGS are not set, USE '-j<NUMBER_OF_PROCESSORS*2>'
: "${MAKEFLAGS:=-j$(($(nproc)*2))}"
export MAKEFLAGS

# extract the kernel source code
cd /build/linux
dpkg-source -x /SRC/linux/*.dsc

# go to linux kernel source directory (name depends on what the current version is)
cd -P /build/linux/linux-*
linux_ver_dir="$PWD"


# add custom patches (if any) and generate corresponding changelog entry
if [ -e /SRC/patches/* ]; then
	echo -e "\n# Custom patches:" >>./debian/patches/series
	quilt import /SRC/patches/*
	# create changelog entry from patches descriptions
	dep3changelog "$(quilt unapplied)" -- $DEBCHANGE_OPTIONS
	# apply custom patches
	quilt push -a
else
	debchange $DEBCHANGE_OPTIONS 'Build with unchanged sources'
fi


# BUILD

date '+%F %T' #date
# apply environment variables configuration (e.g. DEBIAN_KERNEL_DISABLE_DEBUG)
make -f debian/rules source ||:
date '+%F %T' #date
make -f debian/rules.gen setup_${ARCH}_${FEATURESET}_${FLAVOUR}
date '+%F %T' #date
# make packages
make -f debian/rules.gen binary-arch_${ARCH}_${FEATURESET}_${FLAVOUR} binary-indep_${FEATURESET}
date '+%F %T' #date


# move output deb packeges to /build/out directory
mkdir /build/pkgs /build/linux/.workdir ||:
cd /build/linux
mv "$linux_ver_dir" /build/linux/.workdir/
mv /build/linux/* /build/pkgs/
date '+%F %T' #date

