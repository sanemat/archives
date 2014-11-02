#!/bin/bash
# cp html5github.html5 ~/.pandoc/templates/.
~/.cabal/bin/pandoc --template=html5github -f markdown -t html5 index.md -s -o index.html
