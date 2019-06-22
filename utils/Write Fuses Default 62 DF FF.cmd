@echo off
@Call ../firmware/SetPath
color f0
title AvrDude GUI Command Window
@echo. Writing ATtiny85 Hfuse to DF
@echo. trying to connect to device...
avrdude -p ATtiny85 -c stk500v1 -P COM6  -b 19200 -Ulfuse:w:0x62:m -Uhfuse:w:0xdf:m -Uefuse:w:0xff:m -C%AVRDUDE_CONFIG_FILE%
pause