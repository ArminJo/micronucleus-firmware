@echo Upgrade Digispark Bootloader with recommended micronucleus upload. Entry on power on, fast exit if no USB detected, start even without USB pullup connected to VCC.
set FILENAME=upgrade-t85_entry_on_powerOn_activePullup_fastExit.hex
@if exist %FILENAME% (
@rem   ..\windows_exe\avrdude.exe -c micronucleus -p t85 -V -U flash:w:%FILENAME%
%UserProfile%\AppData\Local\Arduino15\packages\digistump\tools\micronucleus\2.0a4\micronucleus --no-ansi --run --timeout 60 %FILENAME%
  goto end
)
@rem Try another path
%UserProfile%\AppData\Local\Arduino15\packages\digistump\tools\micronucleus\2.0a4\micronucleus --no-ansi --run --timeout 60 ..\firmware\upgrades\%FILENAME%
@rem   ..\windows_exe\avrdude.exe -c micronucleus -p t85 -V -U flash:w:..\firmware\upgrades\%FILENAME%
:end
pause