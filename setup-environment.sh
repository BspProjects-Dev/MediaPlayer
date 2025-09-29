#!/bin/bash
# Source Yocto build environment

# Check if build directory exists
if [ ! -d "build" ]; then
    mkdir build
fi

# Source the Yocto environment (Poky)
source meta-rpi-bsp/poky/oe-init-build-env build
echo "Yocto build environment initialized."
