@echo off
color f0
title AvrDude GUI Command Window
@rem Call SetPath
REM The files t85_no_pullup.hex and t85_entry_on_powerOn_no_pullup.hex are identical!
@echo Upgrade Digispark Bootloader with spi programming by avrdude
@echo.
set FILENAME=t85_entry_on_powerOn_activePullup_fastExit.hex
@if exist %FILENAME% (
@rem  avrdude -pt85 -cstk500v1 -PCOM6 -b19200 -u -Uflash:w:%FILENAME%:a
  ..\windows_exe\avrdude.exe -pt85 -cstk500v1 -PCOM6 -b19200 -u -Uflash:w:%FILENAME%:a
  goto end
)
@rem Try another path
@rem avrdude -pt85 -cstk500v1 -PCOM6 -b19200 -u -Uflash:w:..\firmware\releases\%FILENAME%:a
..\windows_exe\avrdude.exe -pt85 -cstk500v1 -PCOM6 -b19200 -u -Uflash:w:..\firmware\releases\%FILENAME%:a
:end
pause
