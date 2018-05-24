# Example 2


Use Core functions to
* Sourced bash file "bash/example.bash"
* Use specific bash binary
* Export 2 go functions into bash context "reverse", "jsonPointer"
* Run bash function "main"


```Go
bash, _ := basher.NewContext("/bin/bash", false)
bash.ExportFunc("json-pointer", jsonPointer)
bash.ExportFunc("reverse", reverse)
if bash.HandleFuncs(os.Args) {
	os.Exit(0)
}

bash.Source("bash/example.bash", Asset)
status, err := bash.Run("main", os.Args[1:])
assert(err)
os.Exit(status)
```
