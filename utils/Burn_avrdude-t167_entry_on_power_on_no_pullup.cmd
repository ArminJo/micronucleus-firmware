@echo off
color f0
title AvrDude GUI Command Window
@Call SetPath
@echo.
@echo Upgrade Digispark Bootloader with spi programming by avrdude
set FILENAME=t167_entry_on_power_on_no_pullup.hex
@if exist %FILENAME% (
  avrdude -pt167 -cstk500v1 -PCOM6 -b19200 -u -Uflash:w:%FILENAME%:a
  goto end
)
@rem Try another path
avrdude -pt167 -cstk500v1 -PCOM6 -b19200 -u -Uflash:w:..\firmware\releases\%FILENAME%:a
:end
pause