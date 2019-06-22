@set ARDUINO_DIRECTORY=E:\Elektro\arduino
@echo Set ARDUINO_DIRECTORY to %ARDUINO_DIRECTORY%
@set AVRDUDE_CONFIG_FILE=%ARDUINO_DIRECTORY%\hardware\tools\avr\etc\avrdude.conf"
@echo Set AVRDUDE_CONFIG_FILE to %AVRDUDE_CONFIG_FILE%
@echo Add arduino, avrdude, launcher and windows "make" executables directory to path
@set PATH=%ARDUINO_DIRECTORY%\hardware\tools\avr\bin;%UserProfile%\AppData\Local\Arduino15\packages\digistump\tools\micronucleus\2.0a4;..\windows_exe;%PATH%
