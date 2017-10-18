all: setup

setup: tmk_core keyboard_build

tmk_core:
	git clone https://github.com/tmk/tmk_core.git

keyboard_build:
	make -C keyboard

