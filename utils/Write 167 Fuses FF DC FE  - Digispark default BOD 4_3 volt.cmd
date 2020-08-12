@echo off
@Call ../firmware/SetPath
color f0
title AvrDude GUI Command Window
@echo. Writing ATtiny167 lfuse 0xFF - External crystal osc. Frequency 8-16 MHz + Startup 65 ms
@echo. Writing ATtiny167 hfuse to 0xDC - External Reset pin enabled + BOD 4.3Volt + Enable Serial Program and Data Downloading
@echo. trying to connect to device...
avrdude -pt167 -cstk500v1 -PCOM6  -b19200 -Ulfuse:w:0xDF:m -Uhfuse:w:0xDC:m -Uefuse:w:0xFE:m
pause