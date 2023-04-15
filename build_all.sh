github_username=martongreber
build_type=debug

layer=base
cd ./$layer
docker build --build-arg username=$github_username \
    --build-arg parent_image=murculus/kudu-${build_type} \
    -t $(whoami)/${layer}_${build_type}_$(uname -m):$(date +%Y%m%d) .
cd ../

layer=cpp_client_example
cd ./$layer
docker build --build-arg parent_image=$(whoami)/base_${build_type}_$(uname -m):$(date +%Y%m%d) \
    -t $(whoami)/${layer}_$(uname -m):$(date +%Y%m%d) .
cd ../

# Docs are built on top of release build.
# build_type=release
# layer=base
# cd ./$layer
# docker build --build-arg username=$github_username \
#     --build-arg parent_image=murculus/kudu-${build_type} \
#     -t $(whoami)/${layer}_${build_type}_$(uname -m):$(date +%Y%m%d) .
# cd ../

# layer=docs
# cd ./${layer}
# docker build --build-arg parent_image=$(whoami)/base_${build_type}_$(uname -m):$(date +%Y%m%d) \
#     -t $(whoami)/${layer}_$(uname -m):$(date +%Y%m%d) .
# cd ../