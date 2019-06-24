@echo off
@Call ../firmware/SetPath
color f0
title AvrDude GUI Command Window
@echo. Writing ATtiny85 fuses to digispark default exept leaving pin5 as reset to enable further low voltage SPI programming
@echo. trying to connect to device...
avrdude -p ATtiny85 -c stk500v1 -P COM6  -b 19200 -Ulfuse:w:0xE1:m -Uhfuse:w:0xDD:m -Uefuse:w:0xFE:m
pause