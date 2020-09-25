@Call SetPath
@echo.
@echo Upgrade Digispark Bootloader with spi programming by avrdude
@if exist t88_always.hex  (
  avrdude -pt88 -cstk500v1 -PCOM6 -b19200 -u -Uflash:w:t88_always.hex:a
  goto end
)
@rem Try another path
avrdude -pt88 -cstk500v1 -PCOM6 -b19200 -u -Uflash:w:..\firmware\releases\t88_always.hex:a
:end
pause
