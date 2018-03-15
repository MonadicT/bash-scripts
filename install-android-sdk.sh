#!/usr/bin/env bash

#
# This script installs Android SDK manager
#

SCRIPTS_DIR=~/scripts

if [[ ! (-d $SCRIPTS_DIR && -f $SCRIPTS_DIR/utilfns.sh) ]]
then
    mkdir -p $SCRIPTS_DIR
    wget -P $SCRIPTS_DIR https://raw.githubusercontent.com/MonadicT/bash-scripts/master/utilfns.sh
fi

source $SCRIPTS_DIR/utilfns.sh

OS=linux
ARCH=arm64 # No way to determine this!

ANDROID_SDK_VERSION=3859397

NODE_VERSION=v8.10.0

DOWNLOAD_DIR=~/Downloads
INSTALL_DIR=~/tools/android-sdk
ANDROID_HOME=$INSTALL_DIR

mkdir -p $DOWNLOAD_DIR
mkdir -p $INSTALL_DIR


# Install/update node and npm
download_if_needed "https://nodejs.org/dist/${NODE_VERSION}/node-${NODE_VERSION}-${OS}-${ARCH}.tar.xz"
if [[ -z /usr/bin/node || $(node -v) != $NODE_VERSION ]]
then
       tar -xvf ${DOWNLOAD_DIR}/node-${NODE_VERSION}-${OS}-${ARCH}.tar.xz
       sudo cp -r node-${NODE_VERSION}-${OS}-${ARCH} /etc/${NODE_VERSION}
       sudo ln -sf /etc/${NODE_VERSION}/bin/node /usr/bin/node
       sudo ln -sf /etc/${NODE_VERSION}/bin/npm /usr/bin/npm
fi

download_if_needed "https://dl.google.com/android/repository/sdk-tools-${OS}-${ANDROID_SDK_VERSION}.zip"
if [[ -z ${INSTALL_DIR}/tools/bin/sdkmanager ]]
then
    (cd $INSTALL_DIR && unzip $DOWNLOAD_DIR/sdk-tools-linux-3859397.zip)
fi

# Modify path
pathrm "$ANDROID_HOME/tools/bin"
pathrm "$ANDROID_HOME/tools/platform-tools"
pathrm "$ANDROID_HOME/tools/emulator"

pathadd "$ANDROID_HOME/tools/bin" after
pathadd "$ANDROID_HOME/platform-tools" after
pathadd "$ANDROID_HOME/emulator" after

# Accept SDK lincense
# FIXME yes|$ANDROID_HOME/tools/bin/sdkmanager --licenses

# Install JDK and RN tools
install_if_needed "default-jdk"
npm_install_if_needed -g create-react-native-app
npm_install_if_needed -g react-native-cli

echo "PATH IS" $PATH

# Environment vars to source
echo ANDROID_HOME=$INSTALL_DIR > set_android_vars.sh
echo PATH=$PATH >> set_android_vars.sh
