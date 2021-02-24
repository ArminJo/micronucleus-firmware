@echo Upgrade Digispark Bootloader with micronucleus upload
set FILENAME=upgrade-t85_default.hex
@if exist %FILENAME% (
  ..\commandline\builds\x86_64-mingw32\micronucleus --no-ansi --run --timeout 60 %FILENAME%
  goto end
)
@rem Try another path
..\commandline\builds\x86_64-mingw32\micronucleus --no-ansi --run --timeout 60 ..\firmware\upgrades\%FILENAME%
:end
pause