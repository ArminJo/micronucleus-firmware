# Micronucleus USB Bootloader for ATtinies / Digisparks
### Version 2.5.1
[![License: GPL v2](https://img.shields.io/badge/License-GPLv2-blue.svg)](https://www.gnu.org/licenses/gpl-2.0)
[![Hit Counter](https://hitcounter.pythonanywhere.com/count/tag.svg?url=https://github.com/ArminJo/micronucleus-firmware)](https://github.com/brentvollebregt/hit-counter)

Micronucleus is a bootloader designed for AVR ATtiny microcontrollers with a minimal usb interface, cross platform libusb-based program upload tool, and a strong emphasis on bootloader compactness. To the authors knowledge this is, by far, the smallest USB bootloader for AVR ATtiny.<br/>
**The V2.0 release is a complete rewrite of the firmware and offers significant improvements over V1.x.**<br/>
Due to the many changes, also the upload tool had to be updated. The V2.0 upload tool is backwards compatible to the V1.X tool, though.

![Digisparks](pictures/Digisparks.jpg)

# Usage
The bootloader allows **uploading of new firmware via USB**. In its usual configuration it is invoked at device power or on reset and will identify to the host computer. If no communication is initiated by the host machine within a given time (default are 6 seconds), the bootloader will time out and enter the user program, if one is present.<br/>
For proper timing, the command line tool should to be started on the host computer **before** the bootloader is invoked / the board attached.<br/>
The bootloader resides in the same memory as the user program, since the ATtiny series does not support a protected bootloader section. Therefore, special care has to be taken not to overwrite the bootloader if the user program uses the self programming features. The bootloader will patch itself into the reset vector of the user program. **No other interrupt vectors are changed**.<br/>
Please invoke the command line tool with "micronucleus -help" for a list of available options.

# Driver installation
For Windows you must install the **libusb driver** before you can program the board. Download it [here](https://github.com/digistump/DigistumpArduino/releases/download/1.6.7/Digistump.Drivers.zip), open it and run `InstallDrivers.exe`.
Clean Micronucleus devices without uploaded userprogram will not time out and allow sufficient time for proper driver installation. Linux and OS X do not require custom drivers.

# Updated configuration for Digispark boards
**The new [Digistump AVR version](https://github.com/ArminJo/DigistumpArduino) shrinks generated code size by 5 to 15 percent**. Just replace the old Digispark board URL **http://digistump.com/package_digistump_index.json** (e.g.in Arduino *File/Preferences*) by the new  **https://raw.githubusercontent.com/ArminJo/DigistumpArduino/master/package_digistump_index.json** and install the latest **Digistump AVR Boards** version.<br/>
![Boards Manager](https://github.com/ArminJo/DigistumpArduino/blob/master/pictures/Digistump1.6.8.jpg)<br/>

# Update the bootloader to the new version
To **update** your old flash consuming **bootloader**, you have 2 choices.
1. Using the [new Digistump board manager](https://github.com/ArminJo/DigistumpArduino#update-the-bootloader) (see above).<br/>
2. Run one of the Windows [scripts](https://github.com/ArminJo/micronucleus-firmware/tree/master/utils)
like e.g. the [Burn_upgrade-t85_default.cmd](utils/Burn_upgrade-t85_default.cmd). The internal mechanism is described [here](https://github.com/ArminJo/micronucleus-firmware/blob/master/firmware/upgrades/README.md).

### If you want to burn the bootloader to an **ATtiny87** or **ATtiny167** with avrdude, you must use the [avrdude.config file](https://raw.githubusercontent.com/ArminJo/micronucleus-firmware/master/windows_exe/avrdude.conf) in `windows_exe` where [ATtiny87](https://github.com/ArminJo/micronucleus-firmware/blob/master/windows_exe/avrdude.conf#L15055) and [ATtiny167](https://github.com/ArminJo/micronucleus-firmware/blob/master/windows_exe/avrdude.conf#L15247) specifications are added.

# Configuration overview
If not otherwise noted, the OSCCAL value is calibrated (+/- 1%) after boot for all ATtiny85 configurations
| Configuration | Available FLASH | Bootloader size | Non default config flags set |
|---------------|-----------------|-----------------|------------------------------|
| t85_aggressive<br/><br/>It works for my Digispark boards without any problems :-) | 6780 | 1392 | [Do not provide calibrated OSCCAL, if no USB attached](/firmware/configuration/t85_aggressive/bootloaderconfig.h#L220), [ENABLE_UNSAFE_OPTIMIZATIONS](#enable_unsafe_optimizations)<br/>Relying on calibrated 16MHz internal clock stability, not using the 16.5 MHz USB driver version with integrated PLL. This causes the main memory saving. |
|  |  |  |  |
| t85_default | 6586 | 1544 | - |
| t85_entry_on_power_on | 6586 | 1586 | [ENTRY_POWER_ON](#entry_power_on-entry-condition), LED_MODE=ACTIVE_HIGH |
| t85_entry_on_power_on_no_pullup | 6586 | 1600 | [ENTRY_POWER_ON](#entry_power_on-entry-condition), [START_WITHOUT_PULLUP](#start_without_pullup), LED_MODE=ACTIVE_HIGH |
| t85_entry_on_power_on_<br/>fast_exit_on_no_USB | 6586 | 1594 | [ENTRY_POWER_ON](#entry_power_on-entry-condition), [START_WITHOUT_PULLUP](#start_without_pullup), [FAST_EXIT_NO_USB_MS=300](#fast_exit_no_usb_ms-for-fast-bootloader-exit), LED_MODE=ACTIVE_HIGH |
| **t85_entry_on_power_on_<br/>no_pullup_fast_exit_on_no_USB**<br/>[recommended configuration](#recommended-configuration) | 6586 | 1590 | [ENTRY_POWER_ON](#entry_power_on-entry-condition), [START_WITHOUT_PULLUP](#start_without_pullup), [FAST_EXIT_NO_USB_MS=300](#fast_exit_no_usb_ms-for-fast-bootloader-exit) |
| t85_entry_on_power_on_pullup_at_0 | 6586 | 1574 | [ENTRY_POWER_ON](#entry_power_on-entry-condition), USB_CFG_PULLUP_IOPORTNAME + USB_CFG_PULLUP_BIT |
| t85_fast_exit_on_no_USB | 6586 | 1570 | [FAST_EXIT_NO_USB_MS=300](#fast_exit_no_usb_ms-for-fast-bootloader-exit), LED_MODE=ACTIVE_HIGH |
| t85_entry_on_reset_no_pullup | 6586 | 1600 | [ENTRY_EXT_RESET](#entry_ext_reset-entry-condition), [START_WITHOUT_PULLUP](#start_without_pullup), LED_MODE=ACTIVE_HIGH |
|  |  |  |  |
| t88_default | 6714 | 1470 | LED_MODE=ACTIVE_HIGH |
| **t88_entry_on_power_on_<br/>no_pullup_fast_exit_on_no_USB**<br/>[recommended configuration](#recommended-configuration) | 6650 | 1516 | [ENTRY_POWER_ON](#entry_power_on-entry-condition), [START_WITHOUT_PULLUP](#start_without_pullup), [FAST_EXIT_NO_USB_MS=300](#fast_exit_no_usb_ms-for-fast-bootloader-exit), LED_MODE=ACTIVE_HIGH |
|  |  |  |  |
| t167_default | 14970 | 1350 | - |
| t167_entry_on_power_on_no_pullup | 14842 | 1394 | [ENTRY_POWER_ON](#entry_power_on-entry-condition), [START_WITHOUT_PULLUP](#start_without_pullup), LED_MODE=ACTIVE_HIGH |
| **t167_entry_on_power_on_<br/>no_pullup_fast_exit_on_no_USB**<br/>[recommended configuration](#recommended-configuration) | 14842 | 1402 | [ENTRY_POWER_ON](#entry_power_on-entry-condition), [START_WITHOUT_PULLUP](#start_without_pullup), [FAST_EXIT_NO_USB_MS=300](#fast_exit_no_usb_ms-for-fast-bootloader-exit), LED_MODE=ACTIVE_HIGH |
| t167_entry_on_reset_no_pullup | 14842 | 1394 | [ENTRY_EXT_RESET](#entry_ext_reset-entry-condition), [START_WITHOUT_PULLUP](#start_without_pullup), LED_MODE=ACTIVE_HIGH |
|  |  |  |  |
| Nanite841 |  | 1594 |  |
| BitBoss |  | 1588 |  |
| t84_default |  | 1520 |  |
|  |  |  |  |
| m168p_extclock |  | 1510 |  |
| m328p_extclock |  | 1510 |  |

### Legend
- [ENTRY_POWER_ON](#entry_power_on-entry-condition) - Only enter bootloader on power on, not on reset or brownout.
- [ENTRY_EXT_RESET](#entry_ext_reset-entry-condition) - Only enter bootloader on reset, not on power up.
- [FAST_EXIT_NO_USB_MS=300](#fast_exit_no_usb_ms-for-fast-bootloader-exit) - If not connected to USB (e.g. powered via VIN) the userprogram starts after 300 ms (+ initial 300 ms) -> 600 ms.
- [START_WITHOUT_PULLUP](#start_without_pullup) - Bootloader does not hang up, if no pullup is activated/connected.
- [ENABLE_SAFE_OPTIMIZATIONS](#enable_safe_optimizations) - jmp 0x0000 does not initialize the stackpointer.
- [LED_MODE=ACTIVE_HIGH](https://github.com/ArminJo/micronucleus-firmware/blob/master/firmware/main.c#L527) - The built in LED flashes during the 5 seconds of the bootloader waiting for commands.

## Computing the values
The actual memory footprint for each configuration can be found in the file [*firmware/build.log*](firmware/build.log).<br/>
Bytes used by the mironucleus bootloader can be computed by taking the data size value in *build.log*, 
rounding it up to the next multiple of the page size which is e.g. 64 bytes for ATtiny85 and 128 bytes for ATtiny176.<br/>
Subtracting this (+ 6 byte for postscript) from the total amount of memory will result in the free bytes numbers.
- Postscript are the few bytes at the end of programmable memory which store tinyVectors.

E.g. for *t85_default.hex* with the new compiler we get 1548 as data size. The next multiple of 64 is 1600 (25 * 64) => (8192 - (1600 + 6)) = **6586 bytes are free**.<br/>
In this case we have 52 bytes left for configuration extensions before using another 64 byte page.<br/>
For *t167_default.hex* (as well as for the other t167 configurations) with the new compiler we get 1436 as data size. The next multiple of 128 is 1536 (12 * 128) => (16384 - (1536 + 6)) = 14842 bytes are free.

# Configuration Options

## [`FAST_EXIT_NO_USB_MS`](/firmware/configuration/t85_fast_exit_on_no_USB/bootloaderconfig.h#L184) for fast bootloader exit
If the bootloader is entered, it requires minimum 300 ms to initialize USB connection (disconnect and reconnect). 
100 ms after this 300 ms initialization, the bootloader receives a reset, if the host application wants to program the device.<br/>
The 100 ms time to reset may depend on the type of host CPU etc., so I took 200 ms to be safe.<br/>
This configuration waits for 200 ms after initialization for a reset and if no reset detected it exits the bootloader and starts the user program.<br/>
With this configuration the **user program is started with a 500 ms delay after power up or reset** even if we do not specify a special entry condition.

## [`ENTRY_POWER_ON`](/firmware/configuration/t85_entry_on_power_on/bootloaderconfig.h#L108) entry condition
The `ENTRY_POWER_ON` configuration adds 18 bytes to the ATtiny85 default configuration.
The content of the `MCUSR` is copied to the `GPIOR0` register to enable the user program to evaluate it and then cleared to prepare for next boot.
In this configuration **a reset will immediately start your userprogram** without any delay.

## [`ENTRY_EXT_RESET`](/firmware/configuration/t85_entry_on_reset_no_pullup/bootloaderconfig.h#L122) entry condition
The ATtiny85 has the bug, that it sets the `External Reset Flag` also on power up. To guarantee a correct behavior for `ENTRY_EXT_RESET` condition, it is checked if only this flag is set **and** `MCUSR` is cleared before start of user program. The latter is done to avoid bricking the device by fogetting to reset the `PORF` flag in the user program.<br/>
For ATtiny167 it is even worse, it sets the `External Reset Flag` and the `Brown-out Reset Flag` also on power up.<br/>
The content of the `MCUSR` is copied to the `GPIOR0` register before clearing it. This enables the user program to evaluate its original content.
**ATTENTION! If the external reset pin is disabled, this entry mode will brick the board!**

## [`START_WITHOUT_PULLUP`](/firmware/configuration/t85_entry_on_power_on_no_pullup_fast_exit_on_no_USB/bootloaderconfig.h#L207)
The `START_WITHOUT_PULLUP` configuration adds 16 to 18 bytes for an additional check. It is required for low energy applications, where the pullup is directly connected to the USB-5V and not to the CPU-VCC. Since this check was contained by default in all pre 2.0 versions, it is obvious that **it can also be used for boards with a pullup**.

## [`ENABLE_SAFE_OPTIMIZATIONS`](/firmware/crt1.S#L99)
This configuration is referenced in the [Makefile.inc](/firmware/configuration/t85_fast_exit_on_no_USB/Makefile.inc#L18) file and will [disable the restoring of the stack pointer](https://github.com/ArminJo/micronucleus-firmware/blob/master/firmware/crt1.S#L102) at the start of program, whis is normally done by reset anyway. These optimization disables reliable entering the bootloader with `jmp 0x0000`, which you should not do anyway - better use the watchdog timer reset functionality.<br/>
- Gains 10 bytes.

## [`ENABLE_UNSAFE_OPTIMIZATIONS`](/firmware/crt1.S#L99)
- Includes [`ENABLE_SAFE_OPTIMIZATIONS`](#enable_safe_optimizations).
- The bootloader reset vector is written by the host and not by the bootloader itself. In case of an disturbed communication the reset vector may be wrong -but I have never experienced it.

You have a slightly bigger chance to brick the bootloader, which reqires it to be reprogrammed by [avrdude](windows_exe) and an ISP or an Arduino as ISP. Command files for this can be found [here](/utils).

## [Recommended](/firmware/configuration/t85_entry_on_power_on_no_pullup_fast_exit_on_no_USB) configuration
The recommended configuration is *entry_on_power_on_no_pullup_fast_exit_on_no_USB*:
- Entry on power on, no entry on reset, ie. after a reset the application starts immediately.
- Start even if pullup is disconnected. Otherwise the bootloader hangs forever, if you commect the Pullup to USB-VCC to save power.
- Fast exit of bootloader (after 600 ms) if there is no host program sending us data (to upload a new userprogram/sketch).

#### Hex files for these configuration are already available in the [releases](/firmware/releases) and [upgrades](/firmware/upgrades) folders.

## Create your own configuration
You can easily create your own configuration by adding a new *firmware/configuration* directory and adjusting *bootloaderconfig.h* and *Makefile.inc*. Before you run the *firmware/make_all.cmd* script, check the arduino directory path in the [`firmware/SetPath.cmd`](https://github.com/ArminJo/micronucleus-firmware/firmware/SetPath.cmd#L1) file.<br/>
If changes to the configuration lead to an increase in bootloader size, it may be necessary to change the bootloader start address as described [above](#computing-the-values) or in the *Makefile.inc*.
Feel free to supply a pull request if you added and tested a previously unsupported device.

# Compile instructions for the bootloader are [here](firmware#compiling)

# Bootloader memory comparison of different releases for [*t85_default.hex*](firmware/releases/t85_default.hex).
- V1.6  6012 bytes free
- V1.11 6330 bytes free
- V2.3  6522 bytes free
- V2.04 6522 bytes free
- V2.5  **6586** bytes free

# USB device manager entry / disconnect from USB
To avoid periodically disconnect->connect if no sketch is loaded and an unknown USB Device (Device Descriptor Request Failed) entry in device manager when entering user program, **the bootloader finishes without an active disconnect from USB**.<br/>
This means that you still can see a libusb-win32 decive / Digispark Bootloader in the Device manager, even when it is not alive, since your program has taken over the control of the CPU.<br/>
This behavior is compatible to the old v1 micronucleus versions, which also do not disconnect from the host.
**You can avoid this by actively disconnecting from the host by pulling the D- line to low for around 300 milliseconds.**<br/>
E.g a short beep at startup with tone(3, 2000, 200) will pull the D- line low and keep the module disconnected.

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
  USB- has a 1.5k pullup resistor to indicate a low-speed device.                  
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
# Revision History
### Version 2.5.1
- Swapped D+ and D- for t88 to support MH-ET LIVE Tiny88 boards.

### Version 2.5
- Saved 2 bytes by removing for loop at leaveBootloader().
- Saved 2 bytes by defining __DELAY_BACKWARD_COMPATIBLE__ for _delay_ms().
- Saved 22 bytes by converting USB_INTR_VECTOR in *usbdrvasm165.inc* from ISR with pushes to a plain function.
- Saved 2 bytes by improving small version of usbCrc16 in *usbdrvasm.S*.
- Saved 4 bytes by inlining usbCrc16 in *usbdrvasm.S*.
- Renamed `AUTO_EXIT_NO_USB_MS` to `FAST_EXIT_NO_USB_MS` and implemented it.
- New configurations using `FAST_EXIT_NO_USB_MS` set to 300 ms.
- Light refactoring and added documentation.
- No USB disconnect at bootloader exit. This avoids "Unknown USB Device" entry in device manager.
- Gained 128 byte for `t167_default` configuration.

- Fixed wrong condition for t85 `ENTRYMODE==ENTRY_EXT_RESET`.
- ATtiny167 support with MCUSR bug/problem at `ENTRY_EXT_RESET` workaround.
- `MCUSR` handling improved.
- no_pullup targets for low energy applications forever loop fixed.
- `USB_CFG_PULLUP_IOPORTNAME` disconnect bug fixed.
- New `ENTRY_POWER_ON` configuration switch, which enables the program to start immediately after a reset.
- Copy `MCUSR` to `GPIOR0` and clear it on exit for all `ENTRY_POWER_ON` and `ENTRY_EXT_RESET` configurations.
