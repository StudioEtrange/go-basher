# Example 2


Use go-basher Application Helper function to
* Embed static bash binaries
* Sourced bash file `scripts/bashfiles/example.bash` which is embedded with go-bindata
* Use autodetected bash binary of the current system
* Export 2 go functions into bash context `reverse`, `jsonPointer`
* Run bash function `main`

As first step, go-bindata is used to embed folder `scripts/bashfiles` folder, with command

```
go-bindata -pkg=bash -o=pkg/bash/bindata.go -prefix=scripts scripts/bashfiles
```

and to embed static bash binary, using `scripts/bash_binaries.sh` script

Which generate go code into pkg/data as a `data` package and pkg/staticbash  as a `staticbash` pacakge which can be used like this :



```Go
basher.Application(
	map[string]func([]string){
		"reverse":      reverse,
		"json-pointer":	jsonPointer,
	}, []string{
		"bashfiles/example.bash",
	},
	"main"
	data.Asset,
	staticbash.RestoreAsset,
	true,
)
```
