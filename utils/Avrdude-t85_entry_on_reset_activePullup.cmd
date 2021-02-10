@Call SetPath
@echo.
@echo Upgrade Digispark Bootloader with spi programming by avrdude
set FILENAME=t85_entry_on_reset_activePullup.hex
@if exist %FILENAME% (
  avrdude -pt85 -cstk500v1 -PCOM6 -b19200 -u -Uflash:w:%FILENAME%:a
  goto end
)
@rem Try another path
avrdude -pt85 -cstk500v1 -PCOM6 -b19200 -u -Uflash:w:..\firmware\releases\%FILENAME%:a
:end
pause
