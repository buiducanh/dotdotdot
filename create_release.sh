#!/bin/bash

SOURCE="${BASH_SOURCE[0]}"
while [ -h "$SOURCE" ]; do # resolve $SOURCE until the file is no longer a symlink
  DIR="$( cd -P "$( dirname "$SOURCE" )" >/dev/null 2>&1 && pwd )"
  SOURCE="$(readlink "$SOURCE")"
  [[ $SOURCE != /* ]] && SOURCE="$DIR/$SOURCE" # if $SOURCE was a relative symlink, we need to resolve it relative to the path where the symlink file was located
done
DIR="$( cd -P "$( dirname "$SOURCE" )" >/dev/null 2>&1 && pwd )"

pushd "$DIR"
rm -rf public
rm -rf build
mkdir -p public
mkdir -p build
cp install-linux.sh build
cp install_tmux.sh build
pushd build
tar -czvf install.tar.gz install-linux.sh install_tmux.sh
popd
cp windows/README.md public/README
cp build/install.tar.gz public
popd

