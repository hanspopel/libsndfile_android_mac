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

export USER_ANDROID_NDK_PATH="$HOME/Library/Android/sdk/ndk/"
export USER_ANDROID_NDK_VERSION="17.2.4988734"
export ANDROID_TOOLCHAIN_HOME=${USER_ANDROID_NDK_PATH}

# Android NDK version number; eg r10, r10b  etc
export ANDROID_NDK_VER=${ANDROID_NDK_VER:-17.2.4988734}

# Android NDK gcc version; eg 4.8, 4.9 etc.
export ANDROID_GCC_VER=${ANDROID_GCC_VER:-4.9}

# Android API version; eg 14 (Android 4.0), 21 (Android 5.0)  etc.
export ANDROID_API_VER=${ANDROID_API_VER:-28}

make clean
rm -R out
mkdir out
./autogen.sh
./Scripts/android-configure_arm64.sh
make
mkdir out/arm64
cp src/.libs/libsndfile.a  out/arm64/libnsdfile_arm64.a

make clean
./autogen.sh
./Scripts/android-configure_armv7.sh
make
mkdir out/armv7
cp src/.libs/libsndfile.a  out/armv7/libnsdfile_armv7.a


make clean
./autogen.sh
./Scripts/android-configure_x86.sh
make
mkdir out/x86
cp src/.libs/libsndfile.a  out/x86/libnsdfile_x86.a
make

make clean
./autogen.sh
./Scripts/android-configure_x86_64.sh
make
mkdir out/x86_64
cp src/.libs/libsndfile.a  out/x86_64/libnsdfile_x86_64.a
make
