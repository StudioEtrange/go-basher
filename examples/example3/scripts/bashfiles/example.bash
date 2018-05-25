set -eo pipefail

hello-bash() {
	echo "Hello world from Bash"
}

main() {
	echo "Arguments:" "$@"
	hello-bash | reverse
	curl -s https://api.github.com/repos/studioetrange/go-basher | json-pointer /owner/login
}
