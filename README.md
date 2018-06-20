# go-basher

A Go library for creating Bash environments, exporting Go functions in them as Bash functions, and running commands in that Bash environment. Combined with a tool like [go-bindata](https://github.com/puppetlabs/go-bindata), you can write programs that are part written in Go and part written in Bash that can be distributed as standalone binaries.

 [![GoDoc](https://godoc.org/github.com/studioetrange/go-basher?status.svg)](http://godoc.org/github.com/studioetrange/go-basher)

## Note on this fork by StudioEtrange

* Add autofind bash binary already present on system
* Extend `Application` helper to use embedded Bash or not
* Extend `Application` helper to launch a specific command (instead of a fixed command)
* Add a new examples with Application helper with or without embedded bash
* Add a new examples with cross-compilation
* Remove useless binary bash files from github repository
* Create a helper script `bash_binaries.sh` to download and generate a go package with a specific bash static version
* Switch repo of [go-bindata](https://github.com/puppetlabs/go-bindata) to https://github.com/puppetlabs/go-bindata
* Improved README.md
* Improved go-basher itself dev env

## Quicktart by examples

* Example using go-basher core functions and one embedded scripts see [example1](examples/example1)
* Example using go-basher Application helper and one embedded scripts see [example2](examples/example2)
* Example using go-basher `Application` helper, two embedded scripts AND embedded bash binary see [example3](examples/example3)

* Example using go-basher `Application` helper, two embedded scripts, embedded bash binary with cross-compilation see [example4](examples/example4)

## Using go-basher core functions

Here we have a simple Go program that defines a `reverse` go function, creates a Bash environment sourcing `example.bash` and then runs `main` bash function in that environment.

```Go
package main

import (
	"os"
	"io/ioutil"
	"log"
	"strings"

	"github.com/studioetrange/go-basher"
)

func reverse(args []string) {
	bytes, err := ioutil.ReadAll(os.Stdin)
	if err != nil {
		log.Fatal(err)
	}
	runes := []rune(strings.Trim(string(bytes), "\n"))
	for i, j := 0, len(runes)-1; i < j; i, j = i+1, j-1 {
		runes[i], runes[j] = runes[j], runes[i]
	}
	println(string(runes))
}

func main() {
	bash, _ := basher.NewContext("/bin/bash", false)
	bash.ExportFunc("reverse", reverse)
	if bash.HandleFuncs(os.Args) {
		os.Exit(0)
	}

	bash.Source("example.bash", nil)
	status, err := bash.Run("main", os.Args[1:])
	if err != nil {
		log.Fatal(err)
	}
	os.Exit(status)
}
```

Here is our `example.bash` file, the actual heart of the program:

```bash
main() {
	echo "Hello world" | reverse
}
```


### go-basher core functions vs Application helper

Instead of manipulating `NewContext`, `ExportFunc`/`HandleFuncs` and `Run`/`Source` functions, you can use `Application` which is a helper built upon theses functions.

## Embedded scripts : How to use

You can bundle your Bash scripts into your Go binary using [go-bindata](https://github.com/puppetlabs/go-bindata), as a `data` go package

* For full example using go-basher core functions and embedded scripts see [example1](examples/example1)
* For full example using go-basher `Application` helper and embedded scripts see [example2](examples/example2)

## Embedded scripts : more explanation

You can bundle your Bash scripts into your Go binary using [go-bindata](https://github.com/puppetlabs/go-bindata). First install go-bindata:

`go get github.com/puppetlabs/go-bindata/...`

Now put all your Bash scripts in a directory called `bashfiles`. The above example program would mean you'd have a `bash/example.bash` file. Run `go-bindata` on the directory:

`go-bindata bashfiles`

This will produce a `bindata.go` file that includes all of your Bash scripts.

> `bindata.go` includes a function called `Asset` that behaves like `ioutil.ReadFile` for files in your `bindata.go`.

Here's how you embed it into the previous example program :

* copy/paste it's import-statements and functions to your application code
* method A : change `bash.Source("bash/example.bash", nil)` into `bash.Source("bash/example.bash, Asset)`
* method B : replace all code in the `main()` function with the `Application()` helper function (see below)

```Go
	basher.Application(
		map[string]func([]string){
			"reverse":      reverse,
		}, []string{
			"bash/example.bash",
		},
		"main"
		Asset,
		nil,
		false,
	)
```



## Batteries included, but replaceable

Did you already hear that term? Sometimes Bash binary is missing, for example when using alpine linux or busybox. Or sometimes its not the correct version. Like OSX ships with Bash 3.x which misses a lot of usefull features. Or you want to make sure to avoid shellshock attack.

For those reasons static versions of Bash binaries can be embedded for linux and darwin. Statically compiled bash are released on github: https://github.com/robxu9/bash-static. These are then turned into go code, with go-bindata: bindata_linux.go and bindata_darwin.go.

When you use the `basher.Application()` function, you have to use a function generated by go-bindata as `loaderBash` parameter so that the built in Bash binary will be extracted into the `~/.basher/` dir.

An help script is provided `scripts/bash_binaries.sh` to download a specific bash version and generate a go package `staticbash`

* For full example using go-basher `Application` helper, embedded scripts AND embedded bash binary see [example3](examples/example3)

## Working on go-basher code source

If you wish to work on go-basher itself, **you'll first need Go installed** on your machine (version 1.9+ is required).

see https://golang.org/


### Install development env

You need to have Go (version 1.9+ is required).
You need to have gnu make.

NOTE : When using Makefile, it will take care of `GOPATH` variable and tree folders organization by creating correct symbolic link. So you can just clone this project anywhere. And not in any particular folder nor any specific `GOPATH` folder.


**Init steps**
* Clone code
```
cd $HOME
git clone https://github.com/StudioEtrange/go-basher
```
* Workdir
```
cd go-basher
```
* Install minimal base and tree folder
```
export GOPATH=$(pwd)
export PATH=$PATH:$GOPATH/bin
make tree
```
* Install some tools
```
make tools
```
* Install dependencies
```
make deps
```
**Build & dev steps**
* Launch code compilation
```
make build
```
* Launch tests
```
make test
```
* Install
```
make install
```

**Test examples**
```
make example-all
```
Or *build example N with :*
```
make exampleN
```
Then *launch example N :*
```
exampleN
```

## Motivation

Go is a great compiled systems language, but it can still be faster to write and glue existing commands together in Bash. However, there are operations you wouldn't want to do in Bash that are straightforward in Go, for example, writing and reading structured data formats. By allowing them to work together, you can use each where they are strongest.

Take a common task like making an HTTP request for JSON data. Parsing JSON is easy in Go, but without depending on a tool like `jq` it is not even worth trying in Bash. And some formats like YAML don't even have a good `jq` equivalent. Whereas making an HTTP request in Go in the *simplest* case is going to be 6+ lines, as opposed to Bash where you can use `curl` in one line. If we write our JSON parser in Go and fetch the HTTP doc with `curl`, we can express printing a field from a remote JSON object in one line:

	curl -s https://api.github.com/users/progrium | parse-user-field email

In this case, the command `parse-user-field` is an app specific function defined in your Go program.

Why would this ever be worth it? I can think of several basic cases:

 1. you're writing a program in Bash that involves some complex functionality that should be in Go
 1. you're writing a CLI tool in Go but, to start, prototyping would be quicker in Bash
 1. you're writing a program in Bash and want it to be easier to distribute, like a Go binary

## License

BSD
