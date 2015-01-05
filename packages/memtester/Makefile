default: build

src:
	wget -O - http://pyropus.ca/software/memtester/old-versions/memtester-4.3.0.tar.gz | tar xz
	mv -f memtester-4.3.0 src

get: src

init:
	cp Makefile.vladik src/Makefile
	rm -rf src/trycpp.c

build:
	make -C src

deploy:
