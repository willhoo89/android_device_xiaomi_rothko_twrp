#!/bin/bash

# Automated TWRP Build Setup for Xiaomi 14T Pro (rothko)
# Run this on WSL2 Ubuntu to set up and build recovery

set -euo pipefail

echo "================================"
echo "TWRP Build Setup - Xiaomi 14T Pro"
echo "================================"

# Color codes
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

log_info() {
  echo -e "${GREEN}[INFO]${NC} $1"
}

log_warn() {
  echo -e "${YELLOW}[WARN]${NC} $1"
}

log_error() {
  echo -e "${RED}[ERROR]${NC} $1"
}

# Check prerequisites
log_info "Checking prerequisites..."

if ! command -v repo &> /dev/null; then
  log_error "repo not found. Please install repo first."
  exit 1
fi

if ! command -v python3 &> /dev/null; then
  log_error "Python 3 not found. Please install Python 3."
  exit 1
fi

if ! command -v git &> /dev/null; then
  log_error "git not found. Please install git."
  exit 1
fi

log_info "Prerequisites OK."

# Setup build directory
BUILD_DIR="$HOME/twrp-build"
mkdir -p "$BUILD_DIR"
cd "$BUILD_DIR"

log_info "Build directory: $BUILD_DIR"

# Install dependencies
log_info "Installing build dependencies (this may take a few minutes)..."
sudo apt update -qq
sudo apt install -y -qq \
  openjdk-11-jdk \
  git curl wget \
  flex bison gperf \
  build-essential zip unzip \
  zlib1g-dev g++-multilib \
  libxml2-utils xsltproc \
  libssl-dev libswitch-perl \
  libc6-dev x11-utils ccache \
  imagemagick lib32ncurses5-dev lib32z1-dev \
  lzma-dev

log_info "Dependencies installed."

# Initialize repo if needed
if [ ! -d .repo ]; then
  log_info "Initializing TWRP source repo..."
  repo init -u https://github.com/TeamWin/android_device_twrp.git -b twrp-14.1 --depth=1
else
  log_info "Repo already initialized."
fi

# Sync source
log_info "Syncing TWRP source (this takes 1-3 hours, ~100GB)..."
log_warn "This is a long operation. Consider running with nohup or screen."
repo sync -c -j$(nproc --all) --force-sync --no-clone-bundle --no-tags

# Place device tree
log_info "Setting up device tree..."
mkdir -p device/xiaomi/rothko

if [ -d device/xiaomi/rothko/.git ]; then
  log_info "Device tree already present, updating..."
  cd device/xiaomi/rothko
  git pull
  cd ../../..
else
  log_info "Cloning device tree..."
  git clone https://github.com/willhoo89/android_device_xiaomi_rothko_twrp.git device/xiaomi/rothko
fi

# Build recovery
log_info "Building TWRP recovery image (this takes 30-60 minutes)..."
log_warn "Make sure you have enough disk space and stable internet."

source build/envsetup.sh
lunch twrp_rothko-eng
mka recoveryimage

# Check result
if [ -f out/target/product/rothko/recovery.img ]; then
  log_info "Build successful!"
  ls -lh out/target/product/rothko/recovery.img
  echo ""
  log_info "Recovery image ready at: $BUILD_DIR/out/target/product/rothko/recovery.img"
  log_info "Next step: Flash to your Xiaomi 14T Pro using fastboot."
else
  log_error "Build failed. Recovery image not found."
  exit 1
fi
