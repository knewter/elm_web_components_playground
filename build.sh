#!/bin/bash

elm package install -y && \
  npm install && \
  bower install && \
  npm run build && \
  mv dist/index.html dist/index_original.html && \
  cp -r src/static . && \
  vulcanize --strip-comments --inline-scripts --inline-css -p . dist/index_original.html | ./node_modules/html-minifier/cli.js -c config/html-minifier.json > dist/index.html

rm -fr static/
rm dist/index_original.html
