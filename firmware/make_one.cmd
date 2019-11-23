@echo off
Call SetPath
if not exist releases MKDIR releases
if not exist upgrades MKDIR upgrades

Set TARGET=m328p_extclock
echo.
echo **********************************************************
echo make Configuration %TARGET%
echo **********************************************************
make clean
make CONFIG=%TARGET%
mv main.hex releases\%TARGET%.hex
mv upgrade.hex upgrades\upgrade-%TARGET%.hex

pause
make clean