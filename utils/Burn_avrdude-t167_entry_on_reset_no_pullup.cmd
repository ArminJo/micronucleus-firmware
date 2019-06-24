@Call ../firmware/SetPath
@echo Upgrade Digispark Bootloader with spi programming by avrdude
@rem lfuse is 0xff instead of 0xe1 for ATtiny85
avrdude -pt167 -cstk500v1 -PCOM6 -b19200 -u -Uflash:w:..\firmware\releases\t167_entry_on_reset_no_pullup.hex:a
pause