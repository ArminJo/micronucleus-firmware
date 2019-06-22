@Call ../firmware/SetPath
@echo Upgrade Digispark Bootloader with spi programming by avrdude
avrdude -pt85 -cstk500v1 -PCOM6 -b19200 -u -Uflash:w:micronucleus-t85-1.06.hex:a -Ulfuse:w:0xe1:m -Uhfuse:w:0xdf:m -Uefuse:w:0xfe:m "-C%AVRDUDE_CONFIG_FILE%
pause