NAME=go-basher
ORG_PATH=github.com/studioetrange
REPO_PATH=$(ORG_PATH)/$(NAME)
MAKEFILE_DIR=$(dir $(abspath $(lastword $(MAKEFILE_LIST))))
ROOT_DIR=$(MAKEFILE_DIR)

default: install

tree:
	@mkdir -p $(ROOT_DIR)src/$(ORG_PATH)
	@ln -s $(ROOT_DIR) src/$(ORG_PATH) || true

tools:
	go get -u github.com/puppetlabs/go-bindata/...

deps:
	go get -u github.com/mitchellh/go-homedir
	go get -u github.com/kardianos/osext

test:
	go test -v

build:
	go build $(REPO_PATH)

install: tree deps tools build
	go install $(REPO_PATH)

example-all: example1 example2 example3 example4

example1: tree
	$(MAKE) -f $(ROOT_DIR)src/$(REPO_PATH)/examples/example1/Makefile

example2: tree
	$(MAKE) -f $(ROOT_DIR)src/$(REPO_PATH)/examples/example2/Makefile

example3: tree
	$(MAKE) -f $(ROOT_DIR)src/$(REPO_PATH)/examples/example3/Makefile

example4: tree
	$(MAKE) -f $(ROOT_DIR)src/$(REPO_PATH)/examples/example4/Makefile
