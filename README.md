# Bootloader for Digispark / Micronucleus Firmware
### Version 2.5 - based on the firmware of [micronucleus v2.04](https://github.com/micronucleus/micronucleus/releases/tag/2.04) 
[![License: GPL v2](https://img.shields.io/badge/License-GPLv2-blue.svg)](https://www.gnu.org/licenses/gpl-2.0)
[![Hit Counter](https://hitcounter.pythonanywhere.com/count/tag.svg?url=https%3A%2F%2Fgithub.com%2FArminJo%2Fmicronucleus-firmware)](https://github.com/brentvollebregt/hit-counter)

Since the [micronucleus repository](https://github.com/micronucleus/micronucleus) seems to be abandoned, I forked the firmware part and try to add all improvements and bug fixes I am aware of. To make the code better understandable, I **added around 50 comment lines**.

# How to update the bootloader to the new version
To update your old flash consuming bootloader you can simply run one of the window [scripts](https://github.com/ArminJo/micronucleus-firmware/tree/master/utils)
like e.g. the [Burn_upgrade-t85_default.cmd](https://github.com/ArminJo/micronucleus-firmware/blob/master/utils/Burn_upgrade-t85_default.cmd).

# Driver installation
For Windows you must install the **Digispark driver** before you can program the board. Download it [here](https://github.com/digistump/DigistumpArduino/releases/download/1.6.7/Digistump.Drivers.zip), open it and run `InstallDrivers.exe`.

# Installation of a better optimizing compiler configuration
**The new Digistmp AVR version 1.6.8 shrinks generated code size by 5 to 15 percent**. Just replace the old Digispark board URL **http://digistump.com/package_digistump_index.json** (e.g.in Arduino *File/Preferences*) by the new  **https://raw.githubusercontent.com/ArminJo/DigistumpArduino/master/package_digistump_index.json** and install the **Digistump AVR Boards** version **1.6.8**.<br/>
![Boards Manager](https://github.com/ArminJo/DigistumpArduino/blob/master/Digistump1.6.8.jpg)

# Memory footprint of the new firmware
The actual memory footprint for each configuration can be found in the file [*firmware/build.log*](https://github.com/ArminJo/micronucleus-firmware/blob/master/firmware/build.log).<br/>
Bytes used by the mironucleus bootloader can be computed by taking the data size value in *build.log*, 
and rounding it up to the next multiple of the page size which is e.g. 64 bytes for ATtiny85 and 128 bytes for ATtiny176.<br/>
Subtracting this (+ 6 byte for postscript) from the total amount of memory will result in the free bytes numbers.
- Postscript are the few bytes at the end of programmable memory which store tinyVectors.

E.g. for *t85_default.hex* with the new compiler we get 1592 as data size. The next multiple of 64 is 1600 (25 * 64) => (8192 - (1600 + 6)) = **6586 bytes are free**.<br/>
In this case we have 8 bytes left for configuration extensions before using another 64 byte page.
So the `START_WITHOUT_PULLUP` and `ENTRY_POWER_ON` configurations are reducing the free bytes amount by 64 to 6522.<br/><br/>
![Upload log](https://github.com/ArminJo/DigistumpArduino/blob/master/Bootloader2.5.jpg)

For *t167_default.hex* (as well as for the other t167 configurations) with the new compiler we get 1436 as data size. The next multiple of 128 is 1536 (12 * 128) => (16384 - (1536 + 6)) = 14842 bytes are free.<br/>

## Bootloader memory comparison of different releases for [*t85_default.hex*](https://github.com/ArminJo/micronucleus-firmware/blob/master/firmware/releases/t85_default.hex).
- V1.6  6012 Byte free
- V1.11 6330 Byte free
- V2.3  6522 Byte free
- V2.04 6522 Byte free
- V2.5  **6586** Byte free (6522 for all other t85 variants)

# Features
## MCUSR now available for sketch
In this version the reset flags in the MCUSR register are no longer cleared by micronucleus and can therefore read out by the sketch!<br/>
If you use the flags in your program or use the `ENTRY_POWER_ON` boot mode, **you must clear them** with `MCUSR = 0;` **after** saving or evaluating them. If you do not reset the flags, and use the `ENTRY_POWER_ON` mode of the bootloader, the bootloader will be entered even after reset, since the power on reset flag in MCUSR is still set!

## New `START_WITHOUT_PULLUP` and `ENTRY_POWER_ON` configurations
- The `START_WITHOUT_PULLUP` configuration adds 16 to 18 bytes for an additional check. It is required for low energy applications, where the pullup is directly connected to the USB-5V. Since this check is contained by default in all pre 2.0 versions,it is obvious that it can also be used for boards with a pullup.
- The `ENTRY_POWER_ON` configuration adds 18 bytes to the ATtiny85 default configuration, but this behavior is **what you normally need** if you use a Digispark board, since it is programmed by attaching to the USB port resulting in power up. In this configuration **a reset will immediately start your sketch** without any delay. Do not forget to **reset the flags in setup()** with `MCUSR = 0;` to make it work!

## Create your own configuration
You can easily create your own configuration by adding a new *firmware/configuration* directory and adjusting *bootloaderconfig.h* and *Makefile.inc*. Before you run the *firmware/make_all.cmd* script, check the arduino binaries path in the `firmware/SetPath.cmd` file.

## This repository contains also an avrdude config file in `windows_exe` with **ATtiny87** and **ATtiny167** data added.

# Revision History
### Version 2.5
- Fixed destroying bootloader for upgrades with entry condition `ENTRY_EXT_RESET`.
- Fixed wrong condition for t85 `ENTRYMODE==ENTRY_EXT_RESET`.
- ATtiny167 support with MCUSR bug/problem at `ENTRY_EXT_RESET` workaround.
- `MCUSR` handling improved.
- no_pullup targets for low energy applications forever loop fixed.
- `USB_CFG_PULLUP_IOPORTNAME` disconnect bug fixed.
- new `ENTRY_POWER_ON` configuration switch, which enables the program to start immediately after a reset.
