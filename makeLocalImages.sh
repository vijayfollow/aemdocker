#!/bin/bash



function build {
  sh -c 'cd '${1}'/ && exec docker build -t aem_6-2_'$(echo ${1} | sed 's/-.*//')' .'
  echo "done building ${1} container"
}

build "base"


build "publish-tar"


build "author-tar"

build "dispatcher-ps"


echo 'All 3 Images are build'
