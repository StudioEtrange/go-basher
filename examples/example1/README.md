# Example 2


Use go-basher core functions to
* Sourced bash file `scripts/bashfiles/example.bash` which is embedded with go-bindata
* Use specific bash binary
* Export 2 go functions into bash context `reverse`, `jsonPointer`
* Run bash function `main`

As first step, go-bindata is used to embed folder `scripts/bashfiles` folder, with command

```
go-bindata -pkg=data -o=pkg/data/bindata.go -prefix=scripts scripts/bashfiles
```
Which generate go code into pkg/data, as a `data` package which can be used like this :


```Go
bash, _ := basher.NewContext("/bin/bash", false)
bash.ExportFunc("json-pointer", jsonPointer)
bash.ExportFunc("reverse", reverse)
if bash.HandleFuncs(os.Args) {
	os.Exit(0)
}

bash.Source("bashfiles/example.bash", data.Asset)
status, err := bash.Run("main", os.Args[1:])
assert(err)
os.Exit(status)
```
