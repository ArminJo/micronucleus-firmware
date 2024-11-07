@echo off
@echo Write fuses in binary format to file "Fuses.raw"
Call SetPath
color f0
title AvrDude GUI Command Window
@echo.
@echo. trying to connect to device...
avrdude -p ATtiny167 -c stk500v1 -P COM6 -b 19200 -U lfuse:r:"Fuses.raw":r -U hfuse:r:"HFuse.raw":r -U efuse:r:"EFuse.raw":r
type HFuse.raw >> Fuses.raw
del HFuse.raw
type EFuse.raw >> Fuses.raw
del EFuse.raw

pause