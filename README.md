# Bootloader for Digispark / Micronucleus Firmware
### Version 2.5 - based on the firmware of [micronucleus v2.04](https://github.com/micronucleus/micronucleus/releases/tag/2.04) 
[![License: GPL v2](https://img.shields.io/badge/License-GPLv2-blue.svg)](https://www.gnu.org/licenses/gpl-2.0)
[![Hit Counter](https://hitcounter.pythonanywhere.com/count/tag.svg?url=https://github.com/ArminJo/micronucleus-firmware)](https://github.com/brentvollebregt/hit-counter)

Here I forked the firmware part of [micronucleus repository](https://github.com/micronucleus/micronucleus) and try to add all improvements and bug fixes I am aware of. To make the code better understandable, I also added a lot of comment lines.

![Digisparks](https://github.com/ArminJo/micronucleus-firmware/blob/master/pictures/Digisparks.jpg)

# How to update the bootloader to the new version
To **update** your old flash consuming **bootloader**, open the Arduino IDE, select *Tools/Programmer: "Micronucleus"* and then run *Tools/Burn Bootloder*.<br/>
![Burn Bootloader](https://github.com/ArminJo/DigistumpArduino/blob/master/pictures/Micronucleus_Burn_Bootloader.jpg)<br/>
The bootloader is the recommended configuration [`entry_on_power_on_no_pullup_fast_exit_on_no_USB`](firmware/configuration/README.md#recommended-configuration).<br/>
Or run one of the window [scripts](https://github.com/ArminJo/micronucleus-firmware/tree/master/utils)
like e.g. the [Burn_upgrade-t85_default.cmd](https://github.com/ArminJo/micronucleus-firmware/tree/master/utils/Burn_upgrade-t85_default.cmd).

# Driver installation
For Windows you must install the **Digispark driver** before you can program the board. Download it [here](https://github.com/digistump/DigistumpArduino/releases/download/1.6.7/Digistump.Drivers.zip), open it and run `InstallDrivers.exe`.

# Installation of a better optimizing compiler configuration
**The new Digistmp AVR version 1.6.8 shrinks generated code size by 5 to 15 percent**. Just replace the old Digispark board URL **http://digistump.com/package_digistump_index.json** (e.g.in Arduino *File/Preferences*) by the new  **https://raw.githubusercontent.com/ArminJo/DigistumpArduino/master/package_digistump_index.json** and install the **Digistump AVR Boards** version **1.6.8**.<br/>
![Boards Manager](https://github.com/ArminJo/DigistumpArduino/blob/master/pictures/Digistump1.6.8.jpg)<br/>
If you use the configurations:
- t85_default
- t85_entry_on_power_on
- t85_fast_exit_on_no_USB
- t85_pullup_at_0
you can change the lines `.upload.maximum_size=6522` to `.upload.maximum_size=6586` in %localappdata%\Arduino15\packages\digistump\hardware\avr\1.6.8\boards.txt to **enable the additonal 64 bytes** of these configurations. 

# Configuration overview is [here](firmware/configuration)

# Memory footprint of the new firmware
The actual memory footprint for each configuration can be found in the file [*firmware/build.log*](https://github.com/ArminJo/micronucleus-firmware/tree/master/firmware/build.log).<br/>
Bytes used by the mironucleus bootloader can be computed by taking the data size value in *build.log*, 
and rounding it up to the next multiple of the page size which is e.g. 64 bytes for ATtiny85 and 128 bytes for ATtiny176.<br/>
Subtracting this (+ 6 byte for postscript) from the total amount of memory will result in the free bytes numbers.
- Postscript are the few bytes at the end of programmable memory which store tinyVectors.

E.g. for *t85_default.hex* with the new compiler we get 1592 as data size. The next multiple of 64 is 1600 (25 * 64) => (8192 - (1600 + 6)) = **6586 bytes are free**.<br/>
In this case we have 8 bytes left for configuration extensions before using another 64 byte page.
So the `START_WITHOUT_PULLUP` and `ENTRY_POWER_ON` configurations are reducing the free bytes amount by 64 to 6522.<br/><br/>
![Upload log](https://github.com/ArminJo/DigistumpArduino/blob/master/pictures/Bootloader2.5.jpg)

For *t167_default.hex* (as well as for the other t167 configurations) with the new compiler we get 1436 as data size. The next multiple of 128 is 1536 (12 * 128) => (16384 - (1536 + 6)) = 14842 bytes are free.<br/>

## Bootloader memory comparison of different releases for [*t85_default.hex*](https://github.com/ArminJo/micronucleus-firmware/tree/master/firmware/releases/t85_default.hex).
- V1.6  6012 bytes free
- V1.11 6330 bytes free
- V2.3  6522 bytes free
- V2.04 6522 bytes free
- V2.5  **6586** bytes free

## This repository contains also an avrdude config file in `windows_exe` with **ATtiny87** and **ATtiny167** data added.

# Pin layout
### ATtiny85 on Digispark

```
                       +-\/-+
 RESET/ADC0 (D5) PB5  1|    |8  VCC
  USB- ADC3 (D3) PB3  2|    |7  PB2 (D2) INT0/ADC1 - default TX Debug output for ATtinySerialOut
  USB+ ADC2 (D4) PB4  3|    |6  PB1 (D1) MISO/DO/AIN1/OC0B/OC1A/PCINT1 - (Digispark) LED
                 GND  4|    |5  PB0 (D0) OC0A/AIN0
                       +----+
  USB+ and USB- are each connected to a 3.3 volt Zener to GND and with a 68 Ohm series resistor to the ATtiny pin.
  On boards with a micro USB connector, the series resistor is 22 Ohm instead of 68 Ohm. 
  USB- has a 1k pullup resistor to indicate a low-speed device (standard says 1k5).                  
  USB+ and USB- are each terminated on the host side with 15k to 25k pull-down resistors.
```

### ATtiny167 on Digispark pro
Digital Pin numbers in braces are for ATTinyCore library

```
                  +-\/-+
RX   6 (D0) PA0  1|    |20  PB0 (D8)  0 OC1AU
TX   7 (D1) PA1  2|    |19  PB1 (D9)  1 OC1BU - (Digispark) LED
     8 (D2) PA2  3|    |18  PB2 (D10) 2 OC1AV
INT1 9 (D3) PA3  4|    |17  PB3 (D11) 4 OC1BV USB-
           AVCC  5|    |16  GND
           AGND  6|    |15  VCC
    10 (D4) PA4  7|    |14  PB4 (D12)   XTAL1
    11 (D5) PA5  8|    |13  PB5 (D13)   XTAL2
    12 (D6) PA6  9|    |12  PB6 (D14) 3 INT0  USB+
     5 (D7) PA7 10|    |11  PB7 (D15)   RESET
                  +----+
  USB+ and USB- are each connected to a 3.3 volt Zener to GND and with a 51 Ohm series resistor to the ATtiny pin.
  USB- has a 1k5 pullup resistor to indicate a low-speed device.
  USB+ and USB- are each terminated on the host side with 15k to 25k pull-down resistors.

```
![DigisparkProPinLayout](https://github.com/ArminJo/micronucleus-firmware/blob/master/pictures/DigisparkProPinLayout.png)

# Revision History
### Version 2.5
- Renamed `AUTO_EXIT_NO_USB_MS` to `FAST_EXIT_NO_USB_MS` and implemented it.
- New configurations using `FAST_EXIT_NO_USB_MS` set to 300 ms.
- Light refactoring and added documentation.
- No USB disconnect at bootloader exit. This avoids "Unknown USB Device" entry in device manager.
- Gained 128 byte for `t167_default` configuration.

- Fixed destroying bootloader for upgrades with entry condition `ENTRY_EXT_RESET`.
- Fixed wrong condition for t85 `ENTRYMODE==ENTRY_EXT_RESET`.
- ATtiny167 support with MCUSR bug/problem at `ENTRY_EXT_RESET` workaround.
- `MCUSR` handling improved.
- no_pullup targets for low energy applications forever loop fixed.
- `USB_CFG_PULLUP_IOPORTNAME` disconnect bug fixed.
- New `ENTRY_POWER_ON` configuration switch, which enables the program to start immediately after a reset.

## Requests for modifications / extensions
Please write me a PM including your motivation/problem if you need a modification or an extension.

#### If you find this library useful, please give it a star. 
