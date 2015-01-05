WD=$(shell pwd)
ifndef DEPLOYDIR
	DEPLOY_DIR=$(WD)/../../target/add-ons
endif
export ARCH=arm
export CROSS_COMPILE=arm-none-linux-gnueabi-

default: build

src:
	tar xf buildroot-2013.05.tar.xz
	mv buildroot-2013.05 src

get: src

init:
	# first lets remove previous configuration and work
	cd src; make distclean
	# lest presetup build root configuration
	cp buildroot-2013.05-spondoolies.bbb src/.config
	# lets remove previous scripts, since it would be regenerated
	@rm -rf tools/customize-rootfs.sh tools/lzma-compress.sh
	touch tools/customize-rootfs.sh
	touch tools/lzma-compress.sh
	# make all scripta executabe
	chmod +x tools/*
	# set initramfs file pointer for kernel
	touch fs.cpio.lzma
	# lets copy kernel coinfig file to build root
	cp spond-kernel-config src/
	# build
	cd src; make

menuconfig:
	cd src; make menuconfig

clean:
	cd src; make clean

build:
deploy:
	@rm -rf tools/customize-rootfs.sh tools/lzma-compress.sh
	ln -s customize-rootfs-real.sh tools/customize-rootfs.sh
	ln -s lzma-compress-real.sh tools/lzma-compress.sh
	@rm -rf src/output/images/*
	cd src; make
	@rm -rf fs.cpio.lzma
	cp -frv ./src/output/images/rootfs.cpio.lzma fs.cpio.lzma
	cd src/output/build/linux-HEAD; make UIMAGE_NAME="SP30_FW:`cat $(DEPLOY_DIR)/../add-ons/fs/fw_ver | tr ' ' '_'`" uImage -j8
	cd src/output/build/linux-HEAD; make spondoolies.dtb -j8
	cp src/output/build/linux-HEAD/arch/arm/boot/uImage ./
	cp src/output/build/linux-HEAD/arch/arm/boot/dts/spondoolies.dtb ./
