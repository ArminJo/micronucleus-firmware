# Makefile initially writen for Little-Wire by Omer Kilic <omerkilic@gmail.com>
# Later on modified by ihsan Kehribar <ihsan@kehribar.me> for Micronucleus bootloader application.

SHELL := /bin/bash

CC=gcc

ifeq ($(shell uname), Linux)
# If you get the error "usb.h: No such file or directory" you must run "sudo apt-get install libusb-dev"
	USBFLAGS=$(shell libusb-config --cflags)
	# Here we can choose to create a dynamic or static binary:
	USBLIBS= -static $(shell libusb-config --libs)
#	USBLIBS=$(shell libusb-config --libs)
	EXE_SUFFIX =
	OSFLAG = -D LINUX
	TARGET_DIR = Linux-x86_64
	ZIPLIB=
else ifeq ($(shell uname), Darwin)
	USBFLAGS=$(shell libusb-config --cflags || libusb-legacy-config --cflags)
	USBLIBS=$(shell libusb-config --libs || libusb-legacy-config --libs)
	EXE_SUFFIX =
	OSFLAG = -D MAC_OS
	# Here we can choose to create a dynamic or static binary:
	# USBLIBS = /opt/local/lib/libusb-legacy/libusb-legacy.a
	USBLIBS += /usr/local/opt/libusb-compat/lib/libusb.a
	USBLIBS += /usr/local/opt/libusb/lib/libusb-1.0.a
#	USBLIBS += -mmacosx-version-min=10.5
#	USBLIBS += -framework CoreFoundation
#	USBLIBS += -framework IOKit
	# Uncomment these to create a dual architecture binary:
	# OSFLAG += -arch x86_64 -arch i386
	TARGET_DIR = Darwin-x86_64
	ZIPLIB=$(shell $(find $(brew --prefix libusb-compat)/lib -name "*dylib" -type f -depth 1))
else ifeq ($(shell uname), OpenBSD)
	USBFLAGS=$(shell libusb-config --cflags || libusb-legacy-config --cflags)
	USBLIBS=$(shell libusb-config --libs || libusb-legacy-config --libs)
	EXE_SUFFIX =
	OSFLAG = -D OPENBSD
else ifeq ($(shell uname), FreeBSD)
	USBFLAGS=
	USBLIBS= -lusb
	EXE_SUFFIX =
	OSFLAG = -D OPENBSD
else # Windows
	USBFLAGS =
	USBLIBS = -lusb0
	EXE_SUFFIX = .exe
	OSFLAG = -D WIN
	TARGET_DIR = Windows
	ZIPLIB=/mingw64/bin/libusb*.dll
endif

LIBS    = $(USBLIBS)
CFLAGS  = $(USBFLAGS) -Ilibrary -O -g $(OSFLAG)

LWLIBS = micronucleus_lib littleWire_util

.PHONY:	clean library store micronucleus

all: micronucleus store
	rm -f *.o

library: $(LWLIBS)

%.o: ./library/%.c
	@echo Building library: $<...
	$(CC) $(CFLAGS) -c $<

micronucleus: $(addsuffix .o, $(LWLIBS))
	@echo Building command line tool: $@$(EXE_SUFFIX)...
	$(CC) $(CFLAGS) -o $@$(EXE_SUFFIX) $@.c $^ $(LIBS)

store: micronucleus
	if [[ ! -d builds/$(TARGET_DIR)/ ]]; then mkdir builds/$(TARGET_DIR); fi
	mv micronucleus$(EXE_SUFFIX) builds/$(TARGET_DIR)
	if [[ -n "$(ZIPLIB)" ]]; then cp -p $(ZIPLIB) builds/$(TARGET_DIR); fi

clean:
	rm -f micronucleus *.o *.exe

install: all
	cp micronucleus /usr/local/bin
