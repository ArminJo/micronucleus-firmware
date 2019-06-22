@Call ../firmware/SetPath
@echo Upgrade Digispark Bootloader with micronucleus upload
launcher -cdigispark -Uflash:w:micronucleus-t85-1.06-upgrade.hex:i
pause