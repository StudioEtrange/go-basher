NAME=go-basher
OWNER=studioetrange
BASH_DIR=workspace/bash
BASH_VER=4.3.42

default: build

test:
	go test -v

build:
	go install || true

deps:
	go get -u github.com/puppetlabs/go-bindata/...

bash:
	rm -rf $(BASH_DIR) && mkdir -p $(BASH_DIR)/linux $(BASH_DIR)/osx
	curl -Ls https://github.com/robxu9/bash-static/releases/download/${BASH_VER}/bash-linux \
		> $(BASH_DIR)/linux/bash
	curl -Ls https://github.com/robxu9/bash-static/releases/download/${BASH_VER}/bash-osx \
		> $(BASH_DIR)/osx/bash
	chmod +x $(BASH_DIR)/**/*
	go-bindata -tags=linux -o=bash_linux.go -prefix=$(BASH_DIR)/linux -pkg=basher $(BASH_DIR)/linux
	go-bindata -tags=darwin -o=bash_darwin.go -prefix=$(BASH_DIR)/osx -pkg=basher $(BASH_DIR)/osx


tools:
	go get -u github.com/kardianos/govendor
	go get -u github.com/puppetlabs/go-bindata/...
