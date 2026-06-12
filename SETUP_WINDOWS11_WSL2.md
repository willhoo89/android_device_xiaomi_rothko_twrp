# TWRP Build Setup for Xiaomi 14T Pro on Windows 11 (WSL2)

## Prerequisites

- Windows 11 25H2
- WSL2 with Ubuntu 22.04+ installed
- `repo` tool installed (you have this ✓)
- Python 3 (you have this ✓)
- ~150GB free disk space in WSL2

## Step-by-step setup

### 1. Open WSL2 Terminal

```bash
wsl
```

### 2. Update system

```bash
sudo apt update && sudo apt upgrade -y
```

### 3. Install build dependencies

```bash
sudo apt install -y \
  openjdk-11-jdk \
  git \
  curl \
  wget \
  flex \
  bison \
  gperf \
  build-essential \
  zip \
  unzip \
  zlib1g-dev \
  g++-multilib \
  libxml2-utils \
  xsltproc \
  libssl-dev \
  libswitch-perl \
  libc6-dev \
  x11-utils \
  ccache \
  imagemagick \
  lib32ncurses5-dev \
  lib32z1-dev
```

### 4. Set up build directory

```bash
mkdir -p ~/twrp-build && cd ~/twrp-build
```

### 5. Initialize TWRP source (this downloads ~100GB)

```bash
repo init -u https://github.com/TeamWin/android_device_twrp.git -b twrp-14.1 --depth=1
```

### 6. Download source

```bash
repo sync -c -j$(nproc --all) --force-sync --no-clone-bundle --no-tags
```

**⏱️ This takes 1-3 hours depending on internet speed.**

### 7. Place device tree

```bash
mkdir -p device/xiaomi/rothko
cd ~/twrp-build
git clone https://github.com/willhoo89/android_device_xiaomi_rothko_twrp.git device/xiaomi/rothko
```

### 8. Build recovery

```bash
cd ~/twrp-build
source build/envsetup.sh
lunch twrp_rothko-eng
mka recoveryimage
```

**⏱️ Build takes 30-60 minutes.**

### 9. Find recovery image

```bash
ls -lh out/target/product/rothko/recovery.img
```

## Next: Flash to device

See `FLASH_INSTRUCTIONS.md` after build completes.
