@echo off
@echo Show fuses as hex
@Call ../firmware/SetPath
color f0
title AvrDude GUI Command Window
@echo.
@echo. trying to connect to device...
avrdude -p ATtiny85 -c stk500v1 -P COM6  -b 19200 -U lfuse:r:"Fuses.hex":h -U hfuse:r:"HFuses.hex":h -U efuse:r:"EFuses.hex":h
@type HFuse.hex >> Fuses.hex
@del HFuse.hex
@type EFuse.hex >> Fuses.hex
@del EFuse.hex
@echo found fuse settings are:
type Fuses.hex
@del Fuses.hex
type
pause