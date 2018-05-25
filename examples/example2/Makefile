MAKEFILE_DIR=$(dir $(abspath $(lastword $(MAKEFILE_LIST))))
ROOT_DIR=$(MAKEFILE_DIR)

default: build

tools:
	go get github.com/puppetlabs/go-bindata/...

data:
	cd $(ROOT_DIR); go-bindata -pkg=data -o=$(ROOT_DIR)/pkg/data/bindata.go -prefix=$(ROOT_DIR)/scripts $(ROOT_DIR)/scripts/bashfiles

build: tools data
	cd $(ROOT_DIR); go get -d -u
	cd $(ROOT_DIR); go build -v
	cd $(ROOT_DIR); go install
