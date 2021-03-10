@echo Upgrade Digispark Bootloader with recommended micronucleus upload. Entry on power on, fast exit if no USB detected, start even without USB pullup connected to VCC.
set FILENAME=upgrade-t88_default.hex
@if exist %FILENAME% (
  ..\commandline\builds\x86_64-mingw32\micronucleus --no-ansi --run --timeout 60 %FILENAME%
  goto end
)
@rem Try another path
..\commandline\builds\x86_64-mingw32\micronucleus --no-ansi --run --timeout 60 ..\firmware\upgrades\%FILENAME%
:end
pause