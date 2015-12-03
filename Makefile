USER=lexty
VERSION=0.15
TAG=$(VERSION)

all: build

download:
	wget https://github.com/spf13/hugo/releases/download/v$(VERSION)/hugo_$(VERSION)_linux_amd64.tar.gz -O hugo.tar.gz && \
	tar xvf hugo.tar.gz && \
	mv ./hugo_$(VERSION)_linux_amd64/hugo_$(VERSION)_linux_amd64 ./hugo_v$(VERSION) && \
	rm -rf hugo_$(VERSION)_linux_amd64 hugo.tar.gz

build:
	[ -f hugo_v$(VERSION) ] || make download VERSION=$(VERSION)

	sed -i "s/ENV[ \t]*HUGO_VERSION[ \t]*[0-9.{} a-z]*/ENV HUGO_VERSION $(VERSION)/gi" Dockerfile
	sed -i "s:COPY ./hugo_v[0-9.{} a-z]* /:COPY ./hugo_v$(VERSION) /:gi" Dockerfile
	docker build -t $(USER)/hugo:$(TAG) .
	make clear-dockerfile

clear-dockerfile:
	sed -i 's/ENV HUGO_VERSION [0-9.{} a-z]*/ENV HUGO_VERSION {{ VERSION }}/gi' Dockerfile
	sed -i 's:COPY ./hugo_v[0-9.{} a-z]* /:COPY ./hugo_v{{ VERSION }} /:gi' Dockerfile

clear: clear-dockerfile
	rm hugo_v*