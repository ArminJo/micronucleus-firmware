@Call SetPath
@echo.
@echo Upgrade Digispark Bootloader with micronucleus upload
@if exist upgrade-t167_entry_on_reset_no_pullup.hex  (
  launcher -cdigispark -Uflash:w:upgrade-t167_entry_on_power_on_no_pullup.hex:i
  goto end
)
@rem Try another path
launcher -cdigispark -Uflash:w:..\firmware\upgrades\upgrade-t167_entry_on_power_on_no_pullup.hex:i
:end
pause
