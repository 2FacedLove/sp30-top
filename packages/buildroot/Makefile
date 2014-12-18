get: 0001_adding_python_modules_for_flask_requests.patch
	tar xf buildroot-2013.05.tar.xz
	mv buildroot-2013.05 src
	@set -i; cd src; for i in $^ ;do patch -p1 <../$$i; done 

init:
	cp buildroot-2013.05-spondoolies.bbb src/.config
	cd src; make oldconfig
	@rm -rf tools/customize-rootfs.sh tools/lzma-compress.sh
	touch tools/customize-rootfs.sh
	touch tools/lzma-compress.sh
	chmod +x tools/*
	make -C src

build:
deploy:
	@rm -rf tools/customize-rootfs.sh tools/lzma-compress.sh
	ln -s customize-rootfs-real.sh tools/customize-rootfs.sh
	ln -s lzma-compress-real.sh tools/lzma-compress.sh
	@rm -rf src/output/images/*
	make -C src
