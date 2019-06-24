@Call ../firmware/SetPath
@echo Upgrade Digispark Bootloader with spi programming by avrdude
avrdude -pt85 -cstk500v1 -PCOM6 -b19200 -u -Uflash:w:t85_default.hex:a
pause