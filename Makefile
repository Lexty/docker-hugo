USER=lexty
HUGO_VERSION=0.15
PYGMENTS_VERSION=2.0.2
TAG=$(HUGO_VERSION)

.PHONY: all download-hugo download-pygmentize build clean-dockerfile clean

all: build

download-hugo:
	mkdir -p build
	wget https://github.com/spf13/hugo/releases/download/v$(HUGO_VERSION)/hugo_$(HUGO_VERSION)_linux_amd64.tar.gz -O build/hugo.tar.gz
	tar xvf build/hugo.tar.gz -C build/
	mv build/hugo_$(HUGO_VERSION)_linux_amd64/hugo_$(HUGO_VERSION)_linux_amd64 build/hugo_v$(HUGO_VERSION)
	rm -rf build/hugo_$(HUGO_VERSION)_linux_amd64 build/hugo.tar.gz

download-pygmentize:
	mkdir -p build
	wget "https://pypi.python.org/packages/source/P/Pygments/Pygments-$(PYGMENTS_VERSION).tar.gz" -O build/pygments-$(PYGMENTS_VERSION).tar.gz
	tar xvf build/pygments-$(PYGMENTS_VERSION).tar.gz -C build/
	mv build/Pygments-$(PYGMENTS_VERSION) build/pygments_v$(PYGMENTS_VERSION)
	rm -rf build/pygments-$(PYGMENTS_VERSION).tar.gz

build:
	[ -f build/hugo_v$(HUGO_VERSION) ] || make download-hugo HUGO_VERSION=$(HUGO_VERSION)
	[ -d build/pygments_v$(PYGMENTS_VERSION) ] || make download-pygmentize PYGMENTS_VERSION=$(PYGMENTS_VERSION)

	sed -i "s/ENV[ \t]*HUGO_VERSION[ \t]*[0-9.{} a-z]*/ENV HUGO_VERSION $(HUGO_VERSION)/gi" Dockerfile
	sed -i "s:COPY ./build/hugo_v[0-9.{} a-z]* /:COPY ./build/hugo_v$(HUGO_VERSION) /:gi" Dockerfile
	sed -i "s:COPY ./build/pygments_v[0-9.{} a-z]* /:COPY ./build/pygments_v$(PYGMENTS_VERSION) /:gi" Dockerfile
	docker build -t $(USER)/hugo:$(TAG) .
	make clear-dockerfile

clean-dockerfile:
	sed -i 's/ENV HUGO_VERSION [0-9.{} a-z]*/ENV HUGO_VERSION {{ HUGO }}/gi' Dockerfile
	sed -i 's:COPY ./build/hugo_v[0-9.{} a-z]* /:COPY ./build/hugo_v{{ HUGO }} /:gi' Dockerfile
	sed -i 's:COPY ./build/pygments_v[0-9.{} a-z]* /:COPY ./build/pygments_v{{ PYGMENTS }} /:gi' Dockerfile

clean: clear-dockerfile
	rm -rf build