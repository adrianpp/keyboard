all: setup keyboard_build

setup: tmk_core check-dfu-programmer check-avr-gcc

tmk_core:
	git clone https://github.com/tmk/tmk_core.git

#check if we have dfu-programmer, and install local copy if not
DFU_PROGRAMMER := $(shell command -v dfu-programmer 2> /dev/null)
ifndef DFU_PROGRAMMER
DFU_INSTALL_LOCATION=$(shell pwd)/dfu
export PATH := $(DFU_INSTALL_LOCATION)/bin:$(PATH)
dfu-programmer:
	git clone https://github.com/dfu-programmer/dfu-programmer.git

dfu-programmer/Makefile: dfu-programmer
	cd dfu-programmer; ./bootstrap.sh; ./configure --prefix=$(DFU_INSTALL_LOCATION)

$(DFU_INSTALL_LOCATION)/bin/dfu-programmer: dfu-programmer/Makefile
	make -C dfu-programmer
	make -C dfu-programmer install

check-dfu-programmer: $(DFU_INSTALL_LOCATION)/bin/dfu-programmer
else
check-dfu-programmer:
endif

#check if we have avr-gcc, and fail if not
AVR_GCC := $(shell command -v avr-gcc 2> /dev/null)
ifndef AVR_GCC
check-avr-gcc:
	$(error "avr-gcc is not available, please install!")
else
check-avr-gcc:
endif

keyboard_build: tmk_core check-dfu-programmer check-avr-gcc
	make -C keyboard

clean:
	make -C keyboard clean

distclean:
ifndef DFU_PROGRAMMER
	rm -rf $(DFU_INSTALL_LOCATION)
	rm -rf dfu-programmer
endif
	rm -rf tmk_core

.PHONY : all setup check-dfu-programmer check-avr-gcc keyboard_build clean distclean

