@echo Upgrade Digispark Bootloader with recommended micronucleus upload. Entry on power on, fast exit if no USB detected, start even without USB pullup connected to VCC.
set FILENAME=upgrade-t88_entry_on_powerOn_activePullup_fastExit.hex
@if exist %FILENAME% (
  %UserProfile%\AppData\Local\Arduino15\packages\digistump\tools\micronucleus\2.0a4\micronucleus --no-ansi --run --timeout 60 %FILENAME%
  goto end
)
@rem Try another path
%UserProfile%\AppData\Local\Arduino15\packages\digistump\tools\micronucleus\2.0a4\micronucleus --no-ansi --run --timeout 60 ..\firmware\upgrades\%FILENAME%
:end
pause