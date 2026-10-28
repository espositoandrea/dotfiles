#!/bin/sh

RELEASE_URL=https://github.com/pandoc/lua-filters/releases/latest
PANDOC_DIR=$HOME/.local/share/pandoc
curl -LSs $RELEASE_URL/download/lua-filters.tar.gz | \
    gtar --strip-components=1 --one-top-level=$PANDOC_DIR -zvxf - lua-filters/filters
