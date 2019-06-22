@Call ../firmware/SetPath
@echo Upgrade Digispark Bootloader with micronucleus upload
launcher -cdigispark -Uflash:w:..\firmware\upgrades\upgrade-t85_no_pullup.hex:i
pause