@echo off
@Call ../firmware/SetPath
color f0
title AvrDude GUI Command Window
@echo Writing ATtiny85 fuses to digispark default except disabling BrownOutDetection, increased startup time and leaving pin5 as reset to enable further low voltage SPI programming
@echo.
@echo Writing ATtiny85 Lfuse to 0xC1 - PLL Clock which is digispark default + Startup 4 ms
@echo Writing ATtiny85 Hfuse to 0xDF - External Reset pin enabled (Pin5 not usable as I/O) + BOD disabled + Enable Serial Program and Data Downloading
@echo Writing ATtiny85 Efuse to 0xFE - self programming enabled.
@echo.
@echo trying to connect to device...
avrdude -p ATtiny85 -c stk500v1 -P COM6  -b 19200 -Ulfuse:w:0xC1:m -Uhfuse:w:0xDF:m -Uefuse:w:0xFE:m
pause