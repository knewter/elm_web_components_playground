#!/usr/bin/env bash
set -e

git checkout -b gh-pages
./build.sh
mv dist /tmp/elm-web-components-playground-dist
rm -fr *
mv /tmp/elm-web-components-playground-dist/* .
rm -fr /tmp/elm-web-components-playground-dist
git add -f .
git commit -m"Update with latest code."
git push -f origin gh-pages
git checkout master
git branch -D gh-pages
