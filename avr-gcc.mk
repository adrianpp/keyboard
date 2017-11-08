AVR_INSTALL_PATH=$(shell pwd)/avrgcc
export PATH := $(AVR_INSTALL_PATH)/bin:$(PATH)

#follow guide from: http://www.nongnu.org/avr-libc/user-manual/install_tools.html
install-avr-gcc:
	$(error "avr-gcc is not available, please install using: sudo apt-get install gcc-avr binutils-avr avr-lib")

remove-avr-gcc:

