# Example 2


Use go-basher Application Helper function to
* Source one bash file `scripts/bashfiles/example.bash` which is embedded with go-bindata
* Use autodetected bash binary of the current system
* Export 2 go functions into bash context `reverse`, `jsonPointer`
* Run bash function `main`

As first step, go-bindata is used to embed folder `scripts/bashfiles` folder, with command

```
go-bindata -pkg=data -o=pkg/data/bindata.go -prefix=scripts scripts/bashfiles
```
Which generate go code into pkg/data, as a `data` package which can be used like this :



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
	nil,
	true,
)
```
