github_username=martongreber
build_type=debug

cd ./base
docker build --build-arg username=$github_username \
    --build-arg parent_image=murculus/kudu-${build_type} \
    -t $(whoami)/base_${build_type}_$(uname -m):$(date +%Y%m%d) .
cd ../

cd ./docs
docker build --build-arg parent_image=$(whoami)/base_${build_type}_$(uname -m):$(date +%Y%m%d) \
    -t $(whoami)/docs_$(uname -m):$(date +%Y%m%d) .
cd ../