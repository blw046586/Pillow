#!/bin/bash
# install libimagequant

archive_name=libimagequant
archive_version=4.3.3

archive=$archive_name-$archive_version

if [[ "$GHA_LIBIMAGEQUANT_CACHE_HIT" == "true" ]]; then

    # Copy cached files into place
    sudo cp ~/cache-$archive_name/libimagequant.so* /usr/lib/
    sudo cp ~/cache-$archive_name/libimagequant.h /usr/include/

else

    # Build from source
    ./download-and-extract.sh $archive https://raw.githubusercontent.com/python-pillow/pillow-depends/main/$archive.tar.gz

    pushd $archive/imagequant-sys

    cargo install cargo-c
    cargo cinstall --prefix=/usr --destdir=.

    # Copy into place
    if [ -d "usr/lib64" ]; then
        lib="lib64"
    else
        lib="lib"
    fi
    sudo cp usr/$lib/libimagequant.so* /usr/lib/
    sudo cp usr/include/libimagequant.h /usr/include/

    if [ -n "$GITHUB_ACTIONS" ]; then
        # Copy to cache
        rm -rf ~/cache-$archive_name
        mkdir ~/cache-$archive_name
        cp usr/lib/libimagequant.so* ~/cache-$archive_name/
        cp usr/include/libimagequant.h ~/cache-$archive_name/
    fi

    popd

fi
