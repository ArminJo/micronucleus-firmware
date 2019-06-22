# Firmware for Micronucleus
Since the [micronucleus repository](https://github.com/micronucleus/micronucleus) seems to be abandoned, I forked the firmware part and try to add all improvements and bug fixes I am aware of.

You can easily build your own configuration by adding your own configuration directory and adjusting the path in the firmware/SetPath.cmd file for with Windows. 

# Revision History
### Version 2.4
- ´MCUSR´ handling improved.
- no_pullup targets for low energy applications forever loop fixed.
- ´USB_CFG_PULLUP_IOPORTNAME´ disconnect bug fixed.
- new ´ENTRY_POWER_ON´ configuration switch, which enables the program to start immediatly after a reset.
