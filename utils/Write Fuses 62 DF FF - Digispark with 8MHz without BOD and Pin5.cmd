@echo off
@Call ../firmware/SetPath
color f0
title AvrDude GUI Command Window
@echo. Writing ATtiny85 lfuse to 0x62 -  8MHz clock + (default) Startup 64 ms
@echo. Writing ATtiny85 hfuse to 0xDF - External Reset pin disabled -> enabled (Pin5 not usable as I/O) + BOD 2.7Volt -> disable + (digispark default) Enable Serial Program and Data Downloading
@echo. trying to connect to device...
avrdude -p ATtiny85 -c stk500v1 -P COM6  -b 19200 -Ulfuse:w:0x62:m -Uhfuse:w:0xdf:m -Uefuse:w:0xff:m
pause