#!/bin/bash

if command -v tmux >/dev/null 2>&1; then
	echo "tmux installed; abort ..."
	exit 1
fi


TMP_DIR=`mktemp -d dl_tmux_artifacts.XXXX`
echo "$TMP_DIR"

api_result=`curl -s https://api.github.com/repos/tmux/tmux/releases/latest`

tag=`echo "$api_result" \
	| grep -iE '"tag_name": "[^"]*"' \
	| sed -e 's@.*"tag_name": "\([^"]*\)".*@\1@g' \
`
echo "tag: $tag"

download_url=`echo "$api_result" \
	| grep -iE '"browser_download_url": "[^"]*'"$tag"'[^"]*"' \
	| sed -e 's@.*"browser_download_url": "\([^"]*'"$tag"'[^"]*\)".*@\1@g' \
`
echo "download_url: $download_url"

pushd "$TMP_DIR"
wget -nc "$download_url"
tmux_tar=`find . -name '*.tar.gz'`
tar -xzf "$tmux_tar"
tmux_dir=`readlink -e \`find . -type d -name "*$tag*"\``
popd

echo "tmux_dir: $tmux_dir"

pushd "$tmux_dir"
./configure && make
code="$?"
if [[ ! "$code" ]]; then
	echo "tmux ./configure && make fails, dumping README"
	echo "********README********"
	cat README
	echo "********README********"
else
	sudo make install
	code="$?"
	if [[ ! "$code" ]]; then
		echo "tmux sudo make install fails, dumping README"
		echo "********README********"
		cat README
		echo "********README********"
	fi
fi
popd

