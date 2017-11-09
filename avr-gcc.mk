AVR_INSTALL_PATH=$(shell pwd)/avrgcc

$(AVR_INSTALL_PATH)/tools.bash:
	git clone https://github.com/arduino/toolchain-avr.git $(AVR_INSTALL_PATH)

$(AVR_INSTALL_PATH)/objdir/avr-gcc: $(AVR_INSTALL_PATH)/tools.bash
	cd $(AVR_INSTALL_PATH) && ./tools.bash && ./binutils.build.bash && ./gcc.build.bash && libc.build.bash

#temporary error message, best way to install is through apt-get
ifdef FORCE_INSTALL
install-avr-gcc: $(AVR_INSTALL_PATH)/objdir/avr-gcc
	cd $(AVR_INSTALL_PATH) && ./tools.bash && ./binutils.build.bash && ./gcc.build.bash && libc.build.bash
else
install-avr-gcc:
	$(error "avr-gcc is not available, please install using: sudo apt-get install gcc-avr binutils-avr avr-libc")
endif

export PATH := $(AVR_INSTALL_PATH)/objdir:$(PATH)

#follow guide from: http://www.nongnu.org/avr-libc/user-manual/install_tools.html

remove-avr-gcc:
	rm -rf $(AVR_INSTALL_PATH)

