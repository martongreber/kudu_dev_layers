
build_base() {
    build_type=$1
    layer=base
    cd ./$layer
    docker build --build-arg username=$github_username \
        --build-arg parent_image=murculus/kudu-${build_type} \
        -t $(whoami)/${layer}_${build_type}_$(uname -m):$(date +%Y%m%d) .
    cd ../
}

build_layer() {
    build_type=$1
    layer=$2
    cd ./$layer
    docker build --build-arg parent_image=$(whoami)/base_${build_type}_$(uname -m):$(date +%Y%m%d) \
        -t $(whoami)/${layer}_$(uname -m):$(date +%Y%m%d) .
    cd ../
}

# For testing purpose
github_username=martongreber
# Most of the time for dev purposes the debug build types are just enough.
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

# build_type=release
# build_base $build_type
# layer=docs
# build_layer $build_type $build_layer
