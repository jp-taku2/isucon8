all: build

.PHONY: clean
clean:
	rm -rf torb

deps:
	gb vendor restore

.PHONY: build
build:
	GO111MODULE=off GOPATH=`pwd`:`pwd`/vendor go build --tags netgo --ldflags '-extldflags "-static"' -v torb
