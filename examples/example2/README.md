# Example 2


Use Application Helper function to
* Sourced bash file "bash/example.bash", which is embedded with gobindata
* Use autodetected bash binary on the current system
* Export 2 go functions into bash context "reverse", "jsonPointer"
* Run bash function "main"

```Go
basher.Application(
	map[string]func([]string){
		"reverse":      reverse,
		"jsonPointer":	jsonPointer,
	}, []string{
		"bash/example.bash",
	},
	"main"
	Asset,
	nil,
	true,
)
```
