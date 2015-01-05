export ARCH=arm
export CROSS_COMPILE=arm-none-linux-gnueabi-

default: build

src:
	git clone ${SPOND_REPOS_REF}/u-boot.git src

get: src
	cd src; git pull

init:
	cd src; make distclean
	cd src; make am335x_evm_config

build:
	cd src; make -j8

deploy: