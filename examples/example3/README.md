# Example 3


Use go-basher Application Helper function to
* Embed static bash binaries
* Source two bash files `scripts/bashfiles/functions.bash` and `scripts/bashfiles/example.bash` which are embedded with go-bindata
* Export 2 go functions into bash context `reverse`, `jsonPointer`
* Run bash function `main`

As first step, go-bindata is used to embed folder `scripts/bashfiles` folder, with command

```
go-bindata -pkg=data -o=pkg/data/bindata.go -prefix=scripts scripts/bashfiles
```

and to embed static bash binary, using `scripts/bash_binaries.sh` script

Which generate go code into pkg/data as a `data` package and pkg/staticbash  as a `staticbash` package which can be used like this :



```Go
basher.Application(
	map[string]func([]string){
		"reverse":      reverse,
		"json-pointer":	jsonPointer,
	}, []string{
		"bashfiles/functions.bash",
		"bashfiles/example.bash",
	},
	"main"
	data.Asset,
	staticbash.RestoreAsset,
	true,
)
```
