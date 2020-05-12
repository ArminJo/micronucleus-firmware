# Configuration overview
| Configuration | Available FLASH | Bootloader size | Non default config flags set |
|---------------|-----------------|-----------------|------------------------------|
| t85_aggressive | 6714 | 1414 | OSCCAL_SAVE_CALIB=0, ENABLE_UNSAFE_OPTIMIZATIONS |
|  |  |  |  |
| t85_default | 6586 | 1584 | - |
| t85_entry_on_power_on | 6586 | 1592 | [ENTRY_POWER_ON](#new-entry_power_on-entry-condition), [ENABLE_SAFE_OPTIMIZATIONS](#implemented-enable_safe_optimizations-configuration-to-save-10-bytes) |
| t85_fast_exit_on_no_USB | 6586 | 1592 | [FAST_EXIT_NO_USB_MS=300](#implemented-auto_exit_no_usb_ms-configuration-for-fast-bootloader-exit), [ENABLE_SAFE_OPTIMIZATIONS](#implemented-enable_safe_optimizations-configuration-to-save-10-bytes) |
| t85_entry_on_power_on_pullup_at_0 | 6586 | 1598 | [ENTRY_POWER_ON](#new-entry_power_on-entry-condition), USB_CFG_PULLUP_IOPORTNAME + USB_CFG_PULLUP_BIT, [ENABLE_SAFE_OPTIMIZATIONS](#implemented-enable_safe_optimizations-configuration-to-save-10-bytes) |
|  |  |  |  |
| t85_entry_on_power_on_no_pullup | 6522 | 1636 | [ENTRY_POWER_ON](#new-entry_power_on-entry-condition), [START_WITHOUT_PULLUP](#new-start_without_pullup-option), LED_MODE=ACTIVE_HIGH |
| t85_entry_on_power_on_no_pullup_fast_exit_on_no_USB | 6522 | 1644 | [ENTRY_POWER_ON](#new-entry_power_on-entry-condition), [START_WITHOUT_PULLUP](#new-start_without_pullup-option), [FAST_EXIT_NO_USB_MS=300](#implemented-auto_exit_no_usb_ms-configuration-for-fast-bootloader-exit), LED_MODE=ACTIVE_HIGH |
| t85_entry_on_reset_no_pullup | 6522 | 1642 | [ENTRY_EXT_RESET](#fixed-wrong-entry_ext_reset-behavior), [START_WITHOUT_PULLUP](#new-start_without_pullup-option), LED_MODE=ACTIVE_HIGH |
|  |  |  |  |
| t167_default | 14970 | 1390 | - |
| t167_entry_on_power_on_no_pullup | 14842 | 1428 | [ENTRY_POWER_ON](#new-entry_power_on-entry-condition), [START_WITHOUT_PULLUP](#new-start_without_pullup-option), LED_MODE=ACTIVE_HIGH |
| t167_entry_on_power_on_no_pullup_fast_exit_on_no_USB | 14842 | 1436 | [ENTRY_POWER_ON](#new-entry_power_on-entry-condition), [START_WITHOUT_PULLUP](#new-start_without_pullup-option), [FAST_EXIT_NO_USB_MS=300](#implemented-auto_exit_no_usb_ms-configuration-for-fast-bootloader-exit), LED_MODE=ACTIVE_HIGH |
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
- [FAST_EXIT_NO_USB_MS=300](#implemented-auto_exit_no_usb_ms-configuration-for-fast-bootloader-exit) - If not connected to USB (e.g. powered via VIN) the sketch starts after 300 ms (+ initial 300 ms) -> 600 ms.
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

## Implemented [`FAST_EXIT_NO_USB_MS`](https://github.com/ArminJo/micronucleus-firmware/tree/master/firmware/configuration/t85_fast_exit_on_no_USB/bootloaderconfig.h#L168) configuration for fast bootloader exit
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
