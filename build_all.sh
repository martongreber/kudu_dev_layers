#!/bin/bash

## Arguments
if [ -z $1 ]; then
    echo "Please supply your github username as the first argument"
fi
github_username=$1


## Docker build functions
# base layer is handled litte bit differently
build_base() {
    build_type=$1
    layer=base
    # tag format: <username>/<layer_name>_<build_type>_<architecture>:<date>
    # example: martongreber/base_debug_x86_64:20230524
    tag=$(whoami)/${layer}_${build_type}_$(uname -m):$(date +%Y%m%d)

    cd ./$layer
    docker build \
        --build-arg username=$github_username \
        --build-arg parent_image=murculus/kudu-${build_type} \
        -t $tag .
    cd ../
}
# building on top of base follows the same pattern
build_layer() {
    build_type=$1
    # refer to the tag from build_base()
    parent_image=$(whoami)/base_${build_type}_$(uname -m):$(date +%Y%m%d)
    # tag format: <username>/<layer_name>_<architecture>:<date>
    # example: martongreber/docs_x86_64:20230524
    tag=$(whoami)/${layer}_$(uname -m):$(date +%Y%m%d)

    cd ./$layer
    docker build \
        --build-arg parent_image=$parent_image \
        -t $tag .
    cd ../
}

main() {
    DIR="$(dirname "${BASH_SOURCE[0]}")"
    cd $DIR

    # First build the base
    build_type=debug
    build_base $build_type

    # Indepent layers which only build on top of base
    independent_layers=("cpp_client_example" \
                        "python_client")
    for layer in ${independent_layers[@]}; do
        build_layer $build_type $layer
    done

    # Docs are built on top of release build. Takes a couple mins as the cache misses alot because of the 
    # different CMake config which is used in make_site.sh

    build_type=release
    build_base $build_type
    layer=docs
    build_layer $build_type $layer
}


SOURCE_ROOT=$(cd $(dirname "$BASH_SOURCE"); pwd)
cd $SOURCE_ROOT

DATE=`date +%d-%m-%y` 
main > /tmp/build-dev-layers-$DATE.log 2>&1 