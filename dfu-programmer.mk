DFU_INSTALL_PATH=$(shell pwd)/dfu
export PATH := $(DFU_INSTALL_PATH)/bin:$(PATH)

$(DFU_INSTALL_PATH)/.marker:
	git clone https://github.com/dfu-programmer/dfu-programmer.git $(DFU_INSTALL_PATH)
	touch $@

$(DFU_INSTALL_PATH)/Makefile: $(DFU_INSTALL_PATH)/.marker
	cd $(DFU_INSTALL_PATH); ./bootstrap.sh; ./configure --prefix=$(DFU_INSTALL_PATH)

$(DFU_INSTALL_PATH)/bin/dfu-programmer: $(DFU_INSTALL_PATH)/Makefile
	make -C $(DFU_INSTALL_PATH)
	make -C $(DFU_INSTALL_PATH) install

install-dfu-programmer: $(DFU_INSTALL_PATH)/bin/dfu-programmer

remove-dfu-programmer:
	rm -rf $(DFU_INSTALL_PATH)

