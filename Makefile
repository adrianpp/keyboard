all: setup keyboard_build

setup: tmk_core check-dfu-programmer check-avr-gcc

tmk_core:
	git clone https://github.com/tmk/tmk_core.git

#check if we have dfu-programmer, and install local copy if not
DFU_PROGRAMMER := $(shell command -v dfu-programmer 2> /dev/null)
ifndef DFU_PROGRAMMER
DFU_INSTALL_PATH=$(shell pwd)/dfu
export PATH := $(DFU_INSTALL_PATH)/bin:$(PATH)
$(DFU_INSTALL_PATH):
	git clone https://github.com/dfu-programmer/dfu-programmer.git $(DFU_INSTALL_PATH)

$(DFU_INSTALL_PATH)/Makefile: $(DFU_INSTALL_PATH)
	cd $(DFU_INSTALL_PATH); ./bootstrap.sh; ./configure --prefix=$(DFU_INSTALL_PATH)

$(DFU_INSTALL_PATH)/bin/dfu-programmer: $(DFU_INSTALL_PATH)/Makefile
	make -C $(DFU_INSTALL_PATH)
	make -C $(DFU_INSTALL_PATH) install

check-dfu-programmer: $(DFU_INSTALL_PATH)/bin/dfu-programmer
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

