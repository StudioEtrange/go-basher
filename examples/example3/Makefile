MAKEFILE_DIR=$(dir $(abspath $(lastword $(MAKEFILE_LIST))))
ROOT_DIR=$(MAKEFILE_DIR)

# go-basher package info
NAME=go-basher
ORG_PATH=github.com/studioetrange
REPO_PATH=$(ORG_PATH)/$(NAME)

# embedded bash info
# see available bash versions here : https://github.com/robxu9/bash-static/releases/
BASH_VER=4.3.42.1

default: build

tools:
	go get github.com/puppetlabs/go-bindata/...

data: bash-binaries
	cd $(ROOT_DIR); go-bindata -pkg=data -o=$(ROOT_DIR)/pkg/data/bindata.go -prefix=$(ROOT_DIR)/scripts $(ROOT_DIR)/scripts/bashfiles


build: tools data
	cd $(ROOT_DIR); go get -d -u
	cd $(ROOT_DIR); go build -v
	cd $(ROOT_DIR); go install


bash-binaries:
	$(GOPATH)/src/$(REPO_PATH)/scripts/bash_binaries.sh "$(ROOT_DIR)/pkg/staticbash" "$(BASH_VER)"
