@Call SetPath
@echo.
@echo Upgrade Digispark Bootloader with spi programming by avrdude
@if exist t88_default.hex  (
  avrdude -pt88 -cstk500v1 -PCOM6 -b19200 -u -Uflash:w:t88_default.hex:a
  goto end
)
@rem Try another path
avrdude -pt88 -cstk500v1 -PCOM6 -b19200 -u -Uflash:w:..\firmware\releases\t88_default.hex:a
:end
pause
