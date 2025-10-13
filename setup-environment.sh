#!/bin/bash
# MediaPlayer Yocto setup script (clean, silent, machine selection only)

# -------------------------------
# Paths
# -------------------------------
LAYER_DIR="./meta-mediaplayer"
MACHINE_CONF_DIR="$LAYER_DIR/conf/machine"
POKY_DIR="./meta-rpi-bsp/poky"   # adjust to your poky path

# -------------------------------
# Check machine conf directory
# -------------------------------
if [ ! -d "$MACHINE_CONF_DIR" ]; then
    echo "Error: Directory not found: $MACHINE_CONF_DIR"
    exit 1
fi

# -------------------------------
# Get all .conf files
# -------------------------------
CONF_FILES=($(find "$MACHINE_CONF_DIR" -maxdepth 1 -type f -name "*.conf" 2>/dev/null))
if [ ${#CONF_FILES[@]} -eq 0 ]; then
    echo "No machine config files found in $MACHINE_CONF_DIR"
    exit 1
fi

# -------------------------------
# List available machines
# -------------------------------
echo "Available build targets:"
for i in "${!CONF_FILES[@]}"; do
    MACHINE_NAME=$(basename "${CONF_FILES[$i]}" .conf)
    echo "$((i+1))) $MACHINE_NAME"
done

# -------------------------------
# Read user input
# -------------------------------
read -p "Enter option (1-${#CONF_FILES[@]}): " OPTION
if ! [[ $OPTION =~ ^[0-9]+$ ]] || [ $OPTION -lt 1 ] || [ $OPTION -gt ${#CONF_FILES[@]} ]; then
    echo "Invalid option!"
exit 1
# -------------------------------
# Determine target machine & config file
# -------------------------------
TARGET_MACHINE=$(basename "${CONF_FILES[$((OPTION-1))]}" .conf)
CONF_FILE="${CONF_FILES[$((OPTION-1))]}"
BUILD_DIR="build-${TARGET_MACHINE}"

echo "Selected machine: $TARGET_MACHINE"
echo "Using config file: $CONF_FILE"
echo "Build directory: $BUILD_DIR"

# -------------------------------
# Create build directory if missing
# -------------------------------
mkdir -p "$BUILD_DIR/conf"

# -------------------------------
# Source Yocto environment silently
# -------------------------------
OE_INIT="$POKY_DIR/oe-init-build-env"
if [ ! -f "$OE_INIT" ]; then
    echo "Error: oe-init-build-env not found in $POKY_DIR"
    exit 1
fi
# Suppress all normal Poky/Yocto messages
source "$OE_INIT" "$BUILD_DIR" >/dev/null 2>&1

# -------------------------------
# Done
# -------------------------------
echo "Environment ready for $TARGET_MACHINE build"
echo "You can now run: bitbake mediaplayer"

fi
