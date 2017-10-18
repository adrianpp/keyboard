all: setup keyboard_build

setup: tmk_core check-dfu-programmer check-avr-gcc

tmk_core:
	git clone https://github.com/tmk/tmk_core.git

#check if we have dfu-programmer, and install local copy if not
DFU_PROGRAMMER := $(shell command -v dfu-programmer 2> /dev/null)
ifndef DFU_PROGRAMMER
include dfu-programmer.mk
check-dfu-programmer: install-dfu-programmer
else
check-dfu-programmer:
remove-dfu-programmer:
endif

#check if we have avr-gcc, and install local copy if not
AVR_GCC := $(shell command -v avr-gcc 2> /dev/null)
ifndef AVR_GCC
include avr-gcc.mk
check-avr-gcc: install-avr-gcc
else
check-avr-gcc:
remove-avr-gcc:
endif

keyboard_build: tmk_core check-dfu-programmer check-avr-gcc
	make -C keyboard

clean:
	make -C keyboard clean

distclean: remove-dfu-programmer remove-avr-gcc
	rm -rf tmk_core

.PHONY : all setup check-dfu-programmer check-avr-gcc install-dfu-programmer install-avr-gcc remove-dfu-programmer remove-avr-gcc keyboard_build clean distclean

