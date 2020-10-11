# Name: Makefile
# Project: Micronucleus
# License: GNU GPL v2 (see License.txt)

# Controller type: ATtiny 85 - 16.5 MHz
# Configuration:   Default + omit language string + FAST_EXIT_NO_USB=700
# Last Change:     Jun 16,2020

#CFLAGS += -DENABLE_SAFE_OPTIMIZATIONS  # This saves 10 bytes and disables reliable jump to 0x0000, which one should avoid anyway.

F_CPU = 16500000
DEVICE = attiny85
FLASHSIZE = 8192
BLOCKSIZE = 64

# hexadecimal address for bootloader section to begin. To calculate the best value:
# - make clean; make main.hex; ### output will list data: 1592 (or something like that)
# - for the size of your device (8kb = 1024 * 8 = 8192) subtract above value = 6598
# - How many pages in is that? 6598 / 64 (tiny85 page size in bytes) = 103.09377
# - round that down to 103 - our new bootloader address is 103 * 64 = 6592, in hex = 19C0
# - free space is 6 byte smaller due to storage for user reset vector and osccal
# - For data size from 1409 to 1472 the address is 1A40 (6714 free)
# - For data size from 1473 to 1536 the address is 1A00 (6650 free)
# - For data size from 1537 to 1600 the address is 19C0 (6586 free)
# - For data size from 1601 to 1664 the address is 1980 (6522 free)
# - For data size from 1665 to 1728 the address is 1940 (6458 free)
BOOTLOADER_ADDRESS = 1A00

FUSEOPT = -U lfuse:w:0xe1:m -U efuse:w:0xfe:m -U hfuse:w:0xdd:m
FUSEOPT_DISABLERESET = -U lfuse:w:0xe1:m -U efuse:w:0xfe:m -U hfuse:w:0x5d:m

#---------------------------------------------------------------------
# ATtiny85
#---------------------------------------------------------------------
#
# Fuse low byte:
# 0xe1 = 1 1 1 0   0 0 0 1
#        ^ ^ \+/   \--+--/
#        | |  |       +------- CKSEL 3..0 (clock selection -> HF PLL)
#        | |  +--------------- SUT 1..0 (BOD enabled, fast rising power)
#        | +------------------ CKOUT (clock output on CKOUT pin -> disabled)
#        +-------------------- CKDIV8 (divide clock by 8 -> don't divide)
#
# Fuse extended byte:
# 0xFE = - - - -   - 1 1 0
#                        ^
#                        |
#                        +---- SELFPRGEN (enable self programming flash)
#
# Fuse high byte:
# 0xdd = 1 1 0 1   1 1 0 1
#        ^ ^ ^ ^   ^ \-+-/
#        | | | |   |   +------ BODLEVEL 2..0 (brownout trigger level -> 2.7V)
#        | | | |   +---------- EESAVE (preserve EEPROM on Chip Erase -> not preserved)
#        | | | +-------------- WDTON (watchdog timer always on -> disable)
#        | | +---------------- SPIEN (enable serial programming -> enabled)
#        | +------------------ DWEN (debug wire enable)
#        +-------------------- RSTDISBL (disable external reset -> enabled)
#
# Fuse high byte ("no reset": external reset disabled, can't program through SPI anymore)
# 0x5d = 0 1 0 1   1 1 0 1
#        ^ ^ ^ ^   ^ \-+-/
#        | | | |   |   +------ BODLEVEL 2..0 (brownout trigger level -> 2.7V)
#        | | | |   +---------- EESAVE (preserve EEPROM on Chip Erase -> not preserved)
#        | | | +-------------- WDTON (watchdog timer always on -> disable)
#        | | +---------------- SPIEN (enable serial programming -> enabled)
#        | +------------------ DWEN (debug wire enable)
#        +-------------------- RSTDISBL (disable external reset -> disabled!)
#
###############################################################################
