all: setup keyboard_build

PROGRAMS=dfu-programmer avr-gcc

setup: tmk_core $(foreach prog, $(PROGRAMS), check-$(prog))

tmk_core:
	git clone https://github.com/tmk/tmk_core.git

#check if we have the required program, and include a makefile fragment to install it if we dont
#makefile fragment must be named NAME.mk, and must define install-NAME and remove-NAME rules
define CHECK_template
CHECK_$(1) := $(shell command -v $(1) 2> /dev/null)
ifndef CHECK_$(1)
include $(1).mk
check-$(1): install-$(1)
else
check-$(1):
install-$(1):
remove-$(1):
endif
endef

#create the check for our required programs
$(foreach prog, $(PROGRAMS), $(eval $(call CHECK_template,$(prog))))

#pass along any make commands to the keyboard directory
keyboard-%:
	make -C keyboard $*

keyboard_build: setup keyboard-all

clean: keyboard-clean

distclean: clean $(foreach prog, $(PROGRAMS), remove-$(prog))
	rm -rf tmk_core

.PHONY : all setup keyboard_build clean distclean $(foreach prog, $(PROGRAMS), check-$(prog) install-$(prog) remove-$(prog))

