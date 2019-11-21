@Call SetPath
REM The files t85_no_pullup.hex and t85_entry_on_power_on_no_pullup.hex are identical!
@echo.
@echo Upgrade Digispark Bootloader with micronucleus upload
@if exist upgrade-t85_entry_on_power_on_no_pullup.hex  (
  launcher -cdigispark -Uflash:w:upgrade-t85_entry_on_power_on_no_pullup.hex:i
  goto end
)
@rem Try another path
launcher -cdigispark -Uflash:w:..\firmware\upgrades\upgrade-t85_entry_on_power_on_no_pullup.hex:i
:end
pause