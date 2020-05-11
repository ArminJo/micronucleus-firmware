# Bootloader for Digispark / Micronucleus Firmware
### Version 2.5 - based on the firmware of [micronucleus v2.04](https://github.com/micronucleus/micronucleus/releases/tag/2.04) 
[![License: GPL v2](https://img.shields.io/badge/License-GPLv2-blue.svg)](https://www.gnu.org/licenses/gpl-2.0)
[![Hit Counter](https://hitcounter.pythonanywhere.com/count/tag.svg?url=https://github.com/ArminJo/micronucleus-firmware)](https://github.com/brentvollebregt/hit-counter)

Here I forked the firmware part of [micronucleus repository](https://github.com/micronucleus/micronucleus) and try to add all improvements and bug fixes I am aware of. To make the code better understandable, I also added a lot of comment lines.

![Digisparks](https://github.com/ArminJo/micronucleus-firmware/blob/master/pictures/Digisparks.jpg)

# How to update the bootloader to the new version
To **update** your old flash consuming **bootloader**, open the Arduino IDE, select *Tools/Programmer: "Micronucleus"* and then run *Tools/Burn Bootloder*.<br/>
![Burn Bootloader](https://github.com/ArminJo/DigistumpArduino/blob/master/pictures/Micronucleus_Burn_Bootloader.jpg)<br/>
The bootloader is the recommended configuration [`entry_on_power_on_no_pullup_fast_exit_on_no_USB`](#recommended-configuration).<br/>
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

# Configuration overview
| Configuration | Available FLASH | Bootloader size | Non default config flags set |
|---------------|-----------------|-----------------|------------------------------|
| t85_aggressive | 6714 | 1414 | OSCCAL_SAVE_CALIB=0, ENABLE_UNSAFE_OPTIMIZATIONS |
|  |  |  |  |
| t85_default | 6586 | 1584 | - |
| t85_entry_on_power_on | 6586 | 1592 | [ENTRY_POWER_ON](#new-entry_power_on-entry-condition), [ENABLE_SAFE_OPTIMIZATIONS](#implemented-enable_safe_optimizations-configuration-to-save-10-bytes) |
| t85_fast_exit_on_no_USB | 6586 | 1592 | [AUTO_EXIT_NO_USB_MS=300](#implemented-auto_exit_no_usb_ms-configuration-for-fast-bootloader-exit), [ENABLE_SAFE_OPTIMIZATIONS](#implemented-enable_safe_optimizations-configuration-to-save-10-bytes) |
| t85_entry_on_power_on_pullup_at_0 | 6586 | 1598 | [ENTRY_POWER_ON](#new-entry_power_on-entry-condition), USB_CFG_PULLUP_IOPORTNAME + USB_CFG_PULLUP_BIT, [ENABLE_SAFE_OPTIMIZATIONS](#implemented-enable_safe_optimizations-configuration-to-save-10-bytes) |
|  |  |  |  |
| t85_entry_on_power_on_no_pullup | 6522 | 1636 | [ENTRY_POWER_ON](#new-entry_power_on-entry-condition), [START_WITHOUT_PULLUP](#new-start_without_pullup-option), LED_MODE=ACTIVE_HIGH |
| t85_entry_on_power_on_no_pullup_fast_exit_on_no_USB | 6522 | 1644 | [ENTRY_POWER_ON](#new-entry_power_on-entry-condition), [START_WITHOUT_PULLUP](#new-start_without_pullup-option), [AUTO_EXIT_NO_USB_MS=300](#implemented-auto_exit_no_usb_ms-configuration-for-fast-bootloader-exit), LED_MODE=ACTIVE_HIGH |
| t85_entry_on_reset_no_pullup | 6522 | 1642 | [ENTRY_EXT_RESET](#fixed-wrong-entry_ext_reset-behavior), [START_WITHOUT_PULLUP](#new-start_without_pullup-option), LED_MODE=ACTIVE_HIGH |
|  |  |  |  |
| t167_default | 14970 | 1390 | - |
| t167_entry_on_power_on_no_pullup | 14842 | 1428 | [ENTRY_POWER_ON](#new-entry_power_on-entry-condition), [START_WITHOUT_PULLUP](#new-start_without_pullup-option), LED_MODE=ACTIVE_HIGH |
| t167_entry_on_power_on_no_pullup_fast_exit_on_no_USB | 14842 | 1436 | [ENTRY_POWER_ON](#new-entry_power_on-entry-condition), [START_WITHOUT_PULLUP](#new-start_without_pullup-option), [AUTO_EXIT_NO_USB_MS=300](#implemented-auto_exit_no_usb_ms-configuration-for-fast-bootloader-exit), LED_MODE=ACTIVE_HIGH |
| t167_entry_on_reset_no_pullup | 14842 | 1436 | [ENTRY_EXT_RESET](#fixed-wrong-entry_ext_reset-behavior), [START_WITHOUT_PULLUP](#new-start_without_pullup-option), LED_MODE=ACTIVE_HIGH |
|  |  |  |  |
| Nanite841 |  | 1608 |  |
| BitBoss |  | 1606 |  |
| t84_default |  | 1534 |  |
|  |  |  |  |
| m168p_extclock |  | 1438 |  |
| m328p_extclock |  | 1438 |  |

### Legend
- [ENTRY_POWER_ON](#new-entry_power_on-entry-condition) - Only enter bootloader on power on, not on reset or brownout.
- [ENTRY_EXT_RESET](#fixed-wrong-entry_ext_reset-behavior) - Only enter bootloader on reset, not on power up.
- [AUTO_EXIT_NO_USB_MS=300](#implemented-auto_exit_no_usb_ms-configuration-for-fast-bootloader-exit) - If not connected to USB (e.g. powered via VIN) the sketch starts after 300 ms (+ initial 300 ms) -> 600 ms.
- [START_WITHOUT_PULLUP](#new-start_without_pullup-option) - Bootloader does not hang up, if no pullup is activated/connected.
- [ENABLE_SAFE_OPTIMIZATIONS](#implemented-enable_safe_optimizations-configuration-to-save-10-bytes) - jmp 0x0000 does not initialize the stackpointer.
- [LED_MODE=ACTIVE_HIGH](https://github.com/ArminJo/micronucleus-firmware/blob/eebe73c46e7780d52c92e6f1c00c72edc26b7769/firmware/main.c#L527) - The built in LED flashes during the 5 seconds of the bootloader waiting for commands.

# New features
## MCUSR content now available in sketch
In this versions the reset flags in the MCUSR register are no longer cleared by micronucleus and can therefore read out by the sketch!<br/>
If you use the flags in your program or use the `ENTRY_POWER_ON` boot mode, **you must clear them** with `MCUSR = 0;` **after** saving or evaluating them. If you do not reset the flags, and use the `ENTRY_POWER_ON` mode of the bootloader, the bootloader will be entered even after a reset, since the power on reset flag in MCUSR is still set!<br/>
For `ENTRY_EXT_RESET` configuration see *Fixed wrong ENTRY_EXT_RESET* below.

## Implemented [`ENABLE_SAFE_OPTIMIZATIONS`](https://github.com/ArminJo/micronucleus-firmware/tree/master/firmware/crt1.S#L99) configuration to save 10 bytes.
This configuration is specified in the [Makefile.inc](https://github.com/ArminJo/micronucleus-firmware/tree/master/firmware/configuration/t85_fast_exit_on_no_USB/Makefile.inc#L18) file and will disable several unnecesary instructions in microncleus. These optimizations disables reliable entering the bootloader with `jmp 0x0000`, which you should not do anyway - better use the watchdog timer reset functionality.<br/>
This is enabled for [t85_entry_on_power_on](https://github.com/ArminJo/micronucleus-firmware/tree/master/firmware/configuration/t85_entry_on_power_on), [t85_fast_exit_on_no_USB](https://github.com/ArminJo/micronucleus-firmware/tree/master/firmware/configuration/t85_fast_exit_on_no_USB) and [t85_pullup_at_0](https://github.com/ArminJo/micronucleus-firmware/tree/master/firmware/configuration/t85_pullup_at_0). It brings no benefit for other configurations.

## Implemented [`AUTO_EXIT_NO_USB_MS`](https://github.com/ArminJo/micronucleus-firmware/tree/master/firmware/configuration/t85_fast_exit_on_no_USB/bootloaderconfig.h#L168) configuration for fast bootloader exit
If the bootloader is entered, it requires 300 ms to initialize USB connection (disconnect and reconnect). 
100 ms after this 300 ms initialization, the bootloader receives a reset, if the host application wants to program the device.<br/>
This enable us to wait for 200 ms after initialization for a reset and if no reset detected to exit the bootloader and start the user program. 
So the user program is started with a 500 ms delay after power up (or reset) even if we do not specify a special entry condition.<br/>
The 100 ms time to reset may depend on the type of host CPU etc., so I took 200 ms to be safe. 

## New [`ENTRY_POWER_ON`](https://github.com/ArminJo/micronucleus-firmware/tree/master/firmware/configuration/t85_entry_on_power_on/bootloaderconfig.h#L156) entry condition
The `ENTRY_POWER_ON` configuration adds 18 bytes to the ATtiny85 default configuration, but this behavior is **what you normally need** if you use a Digispark board, since it is programmed by attaching to the USB port resulting in power up.<br/>
In this configuration **a reset will immediately start your sketch** without any delay.<br/>
Do not forget to **reset the flags in setup()** with `MCUSR = 0;` to make it work!<br/>

## Fixed wrong [`ENTRY_EXT_RESET`](https://github.com/ArminJo/micronucleus-firmware/tree/master/firmware/configuration/t85_entry_on_reset_no_pullup/bootloaderconfig.h#L146) behavior
The ATtiny85 has the bug, that it sets the `External Reset Flag` also on power up. To guarantee a correct behavior for `ENTRY_EXT_RESET` condition, it is checked if only this flag is set **and** all MCUSR flags are **always reset** before start of user program. The latter is done to avoid bricking the device by fogetting to reset the `PORF` flag in the user program.<br/>
The content of the MCUSR is copied to the OCR1C register before clearing the flags. This enables the user program to interprete it.<br/>
For ATtiny167 it is even worse, it sets the `External Reset Flag` and the `Brown-out Reset Flag` also on power up. Here the MCUSR content is copied to the ICR1L register before clearing.<br/>

## New [`START_WITHOUT_PULLUP`](https://github.com/ArminJo/micronucleus-firmware/tree/master/firmware/configuration/t85_entry_on_power_on_no_pullup_fast_exit_on_no_USB/bootloaderconfig.h#L186) option
The `START_WITHOUT_PULLUP` configuration adds 16 to 18 bytes for an additional check. It is required for low energy applications, where the pullup is directly connected to the USB-5V and not to the CPU-VCC. Since this check was contained by default in all pre 2.0 versions, it is obvious that **it can also be used for boards with a pullup**.

## Recommended [configuration](https://github.com/ArminJo/micronucleus-firmware/tree/master/firmware/configuration/t85_entry_on_power_on_no_pullup_fast_exit_on_no_USB)
The recommended configuration is *entry_on_power_on_no_pullup_fast_exit_on_no_USB*:
- Entry on power on, no entry on reset, ie. after a reset the application starts immediately.
- Start even if pullup is disconnected. Otherwise the bootloader hangs forever, if you commect the Pullup to USB-VCC to save power.
- Fast exit of bootloader (after 600 ms) if there is no host program sending us data (to upload a new application/sketch).

#### Hex files for these configuration are already available in the [releases](https://github.com/ArminJo/micronucleus-firmware/tree/master/firmware/releases) and [upgrades](https://github.com/ArminJo/micronucleus-firmware/tree/master/firmware/upgrades) folders.

## Create your own configuration
You can easily create your own configuration by adding a new *firmware/configuration* directory and adjusting *bootloaderconfig.h* and *Makefile.inc*. Before you run the *firmware/make_all.cmd* script, check the arduino binaries path in the `firmware/SetPath.cmd` file.

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
- Support of `AUTO_EXIT_NO_USB_MS`.
- New configurations using `AUTO_EXIT_NO_USB_MS` set to 200 ms.
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
