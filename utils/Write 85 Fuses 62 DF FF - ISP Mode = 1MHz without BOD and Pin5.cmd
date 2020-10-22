@echo off
@Call SetPath
color f0
title AvrDude GUI Command Window
@echo.
@echo Writing ATtiny85 fuses to 8MHz internal clock and clock divider to 8 resulting in an CPU clock of 1 MHz. !!! This is NOT Digispark compatible, you MUST use SPI programming after this fuse settings!!!
@echo. This setting enables to save more power and restart faster from Power Down sleep.
SET AREYOUSURE=N
SET /P AREYOUSURE=Are you sure you want to overwrite the fuses disabling USB programming?(Y/[N])?
IF /I "%AREYOUSURE%" NEQ "Y" GOTO END

@echo.Writing ATtiny85 Lfuse to 0x62 - 8MHz clock, Clock div by 8 -> CPU clock = 1 MHz, 6 Clocks from Power Down sleep + 64 ms after reset.
@echo Writing ATtiny85 Hfuse to 0xDF - External Reset pin enabled (Pin5 not usable as I/O) + BOD disabled + (digispark default) Enable Serial Program and Data Downloading.
@echo Writing ATtiny85 EFuse to 0xFE - self programming enabled.
@echo.
@echo trying to connect to device...
avrdude -p ATtiny85 -c stk500v1 -P COM6  -b 19200 -Ulfuse:w:0x62:m -Uhfuse:w:0xDF:m -Uefuse:w:0xFE:m

pause
exit

:END
@echo Skipped programming fuses
pause