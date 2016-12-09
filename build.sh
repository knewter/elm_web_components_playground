#!/bin/bash

elm package install -y && \
  npm install && \
  bower install && \
  npm run build && \
  mv dist/index.html dist/index_original.html && \
  mkdir -p tmp && \
  cp -r dist tmp/ && \
  cp -r src/static tmp/ && \
  cp -r bower_components tmp/ && \
  pushd tmp && \
  vulcanize --strip-comments --inline-scripts --inline-css -p ./ \
    dist/index_original.html | ../node_modules/html-minifier/cli.js -c \
    ../config/html-minifier.json > ../dist/index.html && \
  popd && \
  rm -fr ./tmp
