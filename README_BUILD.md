# Build instructions for Xiaomi 14T Pro (rothko)

This repository contains the TWRP device tree for Xiaomi 14T Pro (codename `rothko`).

## Prerequisites

- A full Android/TWRP source tree matching the TWRP 14.1 / Android 16 branch.
- This device tree must be located under `device/xiaomi/rothko` in that source tree.

## Placement

Example layout:

```
android_build/
  build/
  frameworks/
  packages/
  device/
    xiaomi/
      rothko/   <-- this repo
```

## Build steps

From the root of the Android build tree:

```bash
source build/envsetup.sh
lunch twrp_rothko-eng
mka recoveryimage
```

## Automated helper

A helper script is included to speed up build invocation if this repo is placed under the build root:

```bash
cd device/xiaomi/rothko
./build_rothko.sh
```
