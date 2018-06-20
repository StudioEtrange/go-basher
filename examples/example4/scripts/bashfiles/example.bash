set -eo pipefail


main() {
	echo "Arguments:" "$@"
	hello-bash | reverse
	curl -s https://api.github.com/repos/studioetrange/go-basher | json-pointer /owner/login
}
