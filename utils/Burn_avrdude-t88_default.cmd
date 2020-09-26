@Call SetPath
@echo.
@echo Upgrade Digispark Bootloader with spi programming by avrdude
set FILENAME=t88_default.hex
@if exist %FILENAME% (
  avrdude -pt88 -cstk500v1 -PCOM6 -b19200 -u -Uflash:w:%FILENAME%:a
  goto end
)
@rem Try another path
avrdude -pt88 -cstk500v1 -PCOM6 -b19200 -u -Uflash:w:..\firmware\releases\%FILENAME%:a
:end
pause
