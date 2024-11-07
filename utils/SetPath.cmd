@echo off
@echo Looking for Arduino installation at default paths
@set ARDUINO_DIRECTORY="C:\Program Files (x86)\Arduino"
@if exist %ARDUINO_DIRECTORY%\hardware\tools\avr\bin\avr-gcc.exe goto setPath
@echo avr-gcc.exe not found in directory %ARDUINO_DIRECTORY%\hardware\tools\avr\bin\avr-gcc.exe
@set ARDUINO_DIRECTORY="C:\Program Files\Arduino IDE"
@if exist %ARDUINO_DIRECTORY%\hardware\tools\avr\bin\avr-gcc.exe goto setPath
@echo avr-gcc.exe not found in directory %ARDUINO_DIRECTORY%\hardware\tools\avr\bin\avr-gcc.exe
@set ARDUINO_DIRECTORY="%localappdata%Program Files\Arduino IDE"
@if exist %ARDUINO_DIRECTORY%\hardware\tools\avr\bin\avr-gcc.exe goto setPath
@echo avr-gcc.exe not found in directory %ARDUINO_DIRECTORY%\hardware\tools\avr\bin\avr-gcc.exe

@set ARDUINO_DIRECTORY=E:\Elektro\arduino
@echo Looking for Arduino installation at user defined directory %ARDUINO_DIRECTORY%
@if exist %ARDUINO_DIRECTORY%\hardware\tools\avr\bin\avr-gcc.exe goto setPath
@echo ERROR - avr-gcc.exe not found in directory %ARDUINO_DIRECTORY%\hardware\tools\avr\bin\avr-gcc.exe
@pause
@exit

:setPath
@echo Add Arduino binaries, Digispark launcher and our windows make.exe directory to path
@set PATH=%ARDUINO_DIRECTORY%\hardware\tools\avr\bin;%UserProfile%\AppData\Local\Arduino15\packages\digistump\tools\micronucleus\2.0a4;..\windows_exe;%PATH%
