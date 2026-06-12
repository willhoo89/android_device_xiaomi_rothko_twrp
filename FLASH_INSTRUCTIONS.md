# Flashing TWRP Recovery to Xiaomi 14T Pro

## Prerequisites

- TWRP recovery image built: `out/target/product/rothko/recovery.img`
- fastboot tool installed
- USB cable connected to device
- Device has USB debugging enabled

## Step 1: Boot device into fastboot

### From Windows (PowerShell as admin):

If device is connected and responsive:
```powershell
adb reboot bootloader
```

If device is stuck/bricked:
1. **Power off the device** (hold power + volume down ~10 sec)
2. **Hold volume down and power** to enter bootloader
3. Device should show "FASTBOOT" mode

## Step 2: Verify fastboot connection

```bash
fastboot devices
```

You should see your device listed.

## Step 3: Flash recovery

```bash
fastboot flash recovery out/target/product/rothko/recovery.img
fastboot reboot recovery
```

Device will reboot into TWRP recovery.

## Step 4: Boot into TWRP

Device should now boot into TWRP. You'll see:
- TWRP logo
- Touch interface
- Main recovery menu

## Step 5: Fix your system in TWRP

### Option A: Wipe and restore (if you have a backup)

1. Tap **Advanced > ADB Sideload**
2. Sideload a working ROM:
   ```bash
   adb sideload rom_file.zip
   ```

### Option B: Wipe system and reformat

1. Tap **Wipe**
2. Swipe to wipe system
3. Flash a working ROM via sideload

## Troubleshooting

### Device not recognized by fastboot
```bash
# Windows: restart ADB
adb kill-server
adb devices
```

### Recovery didn't boot
- Device might have bootloader protection
- Try: `fastboot getvar secure_boot`
- Ensure you're in fastboot mode (should show "fastboot" in console)

### Need to restore stock recovery
- Stock recovery is on the device partition
- Use `fastboot flash recovery` with stock image

## Next: Get a working ROM

You'll need a Xiaomi 14T Pro ROM to flash. Options:
1. **Stock ROM** — from Xiaomi
2. **Custom ROM** — check XDA forums
3. Sideload via ADB

After flashing a ROM in TWRP, reboot to system.
