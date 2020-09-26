@echo Upgrade Digispark Bootloader with recommended micronucleus upload. Entry on power on, fast exit if no USB detected, start even without USB pullup connected to VCC.
set FILENAME=upgrade-t88_entry_on_power_on_no_pullup_fast_exit_on_no_USB.hex
@if exist %FILENAME% (
  %UserProfile%\AppData\Local\Arduino15\packages\digistump\tools\micronucleus\2.0a4\launcher -cdigispark -Uflash:w:%FILENAME%:i
  goto end
)
@rem Try another path
%UserProfile%\AppData\Local\Arduino15\packages\digistump\tools\micronucleus\2.0a4\launcher -cdigispark -Uflash:w:..\firmware\upgrades\%FILENAME%:i
:end
pause