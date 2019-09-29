@echo off
Call SetPath
if not exist releases MKDIR releases
if not exist upgrades MKDIR upgrades

Set TARGET=t167_entry_on_reset_no_pullup
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