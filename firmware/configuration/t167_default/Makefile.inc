# Name: Makefile
# Project: Micronucleus
# License: GNU GPL v2 (see License.txt)
#
# Controller type: ATtiny 167
# Configuration:   Default configuration.
# Last Change:     Mar 16,2014


F_CPU = 16000000
DEVICE = attiny167
AVR_ARCHITECTURE_PARAMETER = --binary-architecture avr:35

# hexadecimal address for bootloader section to begin. To calculate the best value:
# - make clean; make main.hex; ### output will list data: 1410 (or something like that)
# - for the size of your device (16kb = 1024 * 16 = 16384) subtract above value 1410 = 14974
# - How many pages in is that? 14974 / 128 (tiny167 page size in bytes) = 116.984
# - round that down to 116 - our new bootloader address is 116 * 128 = 14848, in hex 3A00
# - For data size up to 1408 the address is 3980 for size from 1409 to 1536 the address is 3A00
BOOTLOADER_ADDRESS = 3A00

FUSEOPT = # TODO
FUSEOPT_DISABLERESET = # TODO
