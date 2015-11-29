#!/bin/bash

VERSION='0.0.1'
ARCH=`uname -m`
OS=`uname -s`
install_dir='/usr/local/bin'

case $ARCH in
    "x86_64")
        ARCH="x86_64"
        ;;
    "i386" | "i586" | "i486" | "i686")
        ARCH="i386"
        ;;
    *)
        echo "$ARCH currently has no precompiled binary"
        ;;
esac

exit_on_fail() {
    if [ $? != 0 ]; then
        echo $1
        exit 1
    fi
}

# echo "https://github.com/kofj/age/releases/download/"

# Download age binary
bin="age.$OS-$ARCH.gz"
binary_url="https://github.com/kofj/age/releases/download/$VERSION/$bin"
tmpbin="/tmp/age"

echo $binary_url

echo "Downloading cow binary $binary_url to $tmpbin.gz"
curl -L "$binary_url" -o $tmpbin.gz || \
    exit_on_fail "Downloading cow binary failed"
gzip -d $tmpbin.gz || exit_on_fail "gzip $tmpbin failed"
chmod +x $tmpbin ||
    exit_on_fail "Can't chmod for $tmpbin"

# Move binary to install directory
echo "Move $tmpbin to $install_dir (will run sudo if no write permission to install directory)"
if [ -w $install_dir ]; then
    mv $tmpbin $install_dir
else
    sudo mv $tmpbin $install_dir
fi
exit_on_fail "Failed to move $tmpbin to $install_dir"
rm $tmpbin