@Call SetPath
@echo.
@echo Upgrade Digispark Bootloader with micronucleus upload
launcher -cdigispark -Uflash:w:upgrade-t85_agressive.hex:i
pause