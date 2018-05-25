#/bin/bash
CURRENT_FILE_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
CURRENT_RUNNING_DIR="$( cd "$( dirname "." )" && pwd )"
WORKSPACE_ROOT="$CURRENT_FILE_DIR/../workspace"
BASH_DIR="$WORKSPACE_ROOT/bash"

# see available bash versions here : https://github.com/robxu9/bash-static/releases/
DEFAULT_BASH_VERSION=4.3.42.1

create_staticbash_bindata() {
  output_dir="$1"
  bash_version="$2"


  [ "${bash_version}" = "" ] && bash_version="${DEFAULT_BASH_VERSION}"
  [ "${output_dir}" = "" ] && output_dir="${CURRENT_RUNNING_DIR}"

  mkdir -p "${BASH_DIR}"

  # download static bash for linux
  current_bash_folder="${BASH_DIR}/${bash_version}/linux"
  if [ ! -f "${current_bash_folder}/bash" ]; then
    mkdir -p "${current_bash_folder}"
    echo "https://github.com/robxu9/bash-static/releases/download/${bash_version}/bash-linux"
    curl -fkSL -o "${current_bash_folder}/bash" "https://github.com/robxu9/bash-static/releases/download/${bash_version}/bash-linux"
  fi

  # download static bash for osx
  current_bash_folder="${BASH_DIR}/${bash_version}/osx"
  if [ ! -f "${current_bash_folder}/bash" ]; then
    mkdir -p "${current_bash_folder}"
    curl -fkSL -o "${current_bash_folder}/bash" "https://github.com/robxu9/bash-static/releases/download/${bash_version}/bash-osx"
  fi

  chmod +x ${BASH_DIR}/${bash_version}/**/*

  go-bindata -tags=linux -o="${output_dir}/bash_linux.go" -prefix="${BASH_DIR}/${bash_version}/linux" -pkg=staticbash ${BASH_DIR}/${bash_version}/linux
  go-bindata -tags=darwin -o="${output_dir}/bash_darwin.go" -prefix="${BASH_DIR}/${bash_version}/osx" -pkg=staticbash ${BASH_DIR}/${bash_version}/osx
}


create_staticbash_bindata $1 $2
