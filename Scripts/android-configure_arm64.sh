#!/bin/bash -e

# Copyright (C) 2013-2016 Erik de Castro Lopo <erikd@mega-nerd.com>
#
# All rights reserved.
#
# Redistribution and use in source and binary forms, with or without
# modification, are permitted provided that the following conditions are
# met:
#
#     * Redistributions of source code must retain the above copyright
#       notice, this list of conditions and the following disclaimer.
#     * Neither the author nor the names of any contributors may be used
#       to endorse or promote products derived from this software without
#       specific prior written permission.
#
# THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
# "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED
# TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR
# PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR
# CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL,
# EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO,
# PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS;
# OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY,
# WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR
# OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF
# ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
# /Users/pascalkaap/Library/Android/sdk/ndk/16.1.4479499
# Android NDK version number; eg r10, r10b  etc


# ANDROID_TARGET=${ANDROID_TARGET:-arm-linux-androideabi}
ANDROID_TARGET=${ANDROID_TARGET:-aarch64-linux-android}

ANDROID_ARCH="arch-arm64"

# aarch64-linux-android


if test -z ${ANDROID_TOOLCHAIN_HOME} ; then
	echo "Environment variable ANDROID_TOOLCHAIN_HOME not defined."
	echo "This should point to the directory containing the Android NDK."
    exit 1
	fi

#-------------------------------------------------------------------------------
# No more user config beyond here.

BUILD_MACHINE=$(uname -s | tr 'A-Z' 'a-z')-$(uname -m)

function die_with {
	echo $1
	exit 1
}

export CROSS_COMPILE=${ANDROID_TARGET}

# Don't forget to adjust this to your NDK path
export ANDROID_NDK=${ANDROID_TOOLCHAIN_HOME}/${ANDROID_NDK_VER}
test -d ${ANDROID_NDK} || die_with "Error : ANDROID_NDK '$ANDROID_NDK' does not exist."

# export ANDROID_PREFIX=${ANDROID_NDK}/toolchains/arm-linux-androideabi-${ANDROID_GCC_VER}/prebuilt/${BUILD_MACHINE}

export ANDROID_PREFIX=${ANDROID_NDK}/toolchains/${ANDROID_TARGET}-${ANDROID_GCC_VER}/prebuilt/${BUILD_MACHINE}
test -d ${ANDROID_PREFIX} || die_with "Error : ANDROID_PREFIX '$ANDROID_PREFIX' does not exist."

export SYSROOT=${ANDROID_NDK}/platforms/android-${ANDROID_API_VER}/${ANDROID_ARCH}

# export SYSROOT=${ANDROID_NDK}/platforms/android-${ANDROID_API_VER}/arch-arm
test -d ${SYSROOT} || die_with "Error : SYSROOT '$SYSROOT' does not exist."

export CROSS_PREFIX=${ANDROID_PREFIX}/bin/aarch64-linux-android
test -f ${CROSS_PREFIX}-gcc || die_with "Error : CROSS_PREFIX compiler '${CROSS_PREFIX}-gcc' does not exist."


# Non-exhaustive lists of compiler + binutils
# Depending on what you compile, you might need more binutils than that
export CPP=${CROSS_PREFIX}-cpp
export AR=${CROSS_PREFIX}-ar
export AS=${CROSS_PREFIX}-as
export NM=${CROSS_PREFIX}-nm
export CC=${CROSS_PREFIX}-gcc
export CXX=${CROSS_PREFIX}-g++
export LD=${CROSS_PREFIX}-ld
export RANLIB=${CROSS_PREFIX}-ranlib

# Don't mix up .pc files from your host and build target
export PKG_CONFIG_PATH=${PREFIX}/lib/pkgconfig
# -I${ANDROID_NDK}/sources/cxx-stl/gnu-libstdc++/${ANDROID_GCC_VER}/libs/armbi/include 
export CFLAGS="${CFLAGS} --sysroot=${SYSROOT} -I${ANDROID_NDK}/sysroot/usr/include -I${ANDROID_NDK}/sysroot/usr/include/aarch64-linux-android -I${ANDROID_PREFIX}/include"
export CXXFLAGS="${CXXFLAGS} -fno-exceptions --sysroot=${SYSROOT} -I${ANDROID_NDK}/sysroot/usr/include -I${ANDROID_NDK}/sysroot/usr/include/aarch64-linux-android -I${ANDROID_PREFIX}/include -I${ANDROID_NDK}/sources/cxx-stl/gnu-libstdc++/${ANDROID_GCC_VER}/include/ -I${ANDROID_NDK}/sources/cxx-stl/gnu-libstdc++/${ANDROID_GCC_VER}/libs/arm64-v8a/include"

export CPPFLAGS="${CFLAGS}"
export LDFLAGS="${LDFLAGS} -L${SYSROOT}/usr/lib -L${ANDROID_PREFIX}/lib"
# Create a symlink to the gdbclient.
test -h gdbclient || ln -s ${ANDROID_PREFIX}/bin/aarch64-linux-android-gdb gdbclient

./configure --host=${CROSS_COMPILE} --with-sysroot=${SYSROOT} "$@" 
