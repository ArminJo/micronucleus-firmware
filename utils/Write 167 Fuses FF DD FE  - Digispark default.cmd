@echo off
@Call ../firmware/SetPath
color f0
title AvrDude GUI Command Window
@echo. Writing ATtiny167 lfuse 0xFF - External crystal osc. Frequency 8-16 MHz + Startup 65 ms
@echo. Writing ATtiny167 hfuse to 0xDD - External Reset pin enabled + BOD 2.7Volt + Enable Serial Program and Data Downloading
@echo. trying to connect to device...
avrdude -pt167 -cstk500v1 -PCOM6  -b19200 -Ulfuse:w:0xFF:m -Uhfuse:w:0xDD:m -Uefuse:w:0xFE:m
pause