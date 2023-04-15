# Kudu dev layers

Pre-build Kudu developer images are pushed to Dockerhub(root images). This repository contains 
information on how to add customised layers(base, etc.) on top of these. Moreover how to use VSCode
to attach to a running dev container.

## Getting started
Prerequisites, install VSCode and install the following extensions
- Docker (ms-azuretools.vscode-docker)
- Dev Containers (ms-vscode-remote.remote-containers)
- (Remote - SSH (ms-vscode-remote.remote-ssh) in case of development on remote host)
1. Docker pull murculus/kudu-debug:{x86_64/aarch64}
1. Setup SSH agent (https://kb.iu.edu/d/aeww), for example:
    - .bashrc <- ``eval `ssh-agent` && ssh-add ~/.ssh/id_ed25519``
    - .bash_logout <- kill $SSH_AGENT_PID
1. Build the base image: `cd ./base && docker build --build-arg username=<github username> -t $(whoami)/base_debug_$(uname -m):$(date +%Y%m%d) .`
1. Open VSCode, click the Docker icon:
    - under 'IMAGES' look for your image $(whoami)/base
    - hit the dropdown, right click the latest tag then 'Run interactive'
    - under 'CONTAINERS' now the image is running, right click it 'Attach Visual Studio Code'
1. Congrats, you have a running Kudu dev container with VSCode attached!
1. Navigate into the build folder and run ninja:
    - cd $KUDU_HOME/build/debug && ninja

## Different root image build types
All four C++ build types are pushed to Dockerhub:
* murculus/kudu-debug
* murculus/kudu-release
* murculus/kudu-asan
* murculus/kudu-tsan

The parent_image build argument can be specified to change the root image in the base layer:

```
cd ./base 
build_type=tsan
docker build \
    --build-arg username=<github username> \
    --build-arg parent_image=murculus/kudu-${build_type} \
    -t \$(whoami)/tsan_${build_type}_$(uname -m):\$(date +%Y%m%d) .
```

## Fork based development workflow

## Adding new layers
Everyone should put common tooling, dotfiles, themes into the base layer. Then the base image should
be used to create further layers for specific tast: C++ specific image, java, docs etc.

Let's create a small layer for building Kudu docs!
We have to add a new folder into the root of this project. Indicating that this is a layer for a
given functionality. We would like to create a Dockerfile which can be built with the base layer as 
the parent. It needs to start with something like:

```
ARG parent_image
from ${parent_image}
```

Then we can just add all the necessary setup steps to have everything setup for docs building. (see ./docs/Dockerfile)
Now we need to build it. First we need to make sure that the base image is built, then we build on top of that:
```
cd ./base
build_type=release
docker build --build-arg username=<github username> \
    --build-arg parent_image=murculus/kudu-${build_type} \
    -t $(whoami)/base_${build_type}_$(uname -m):$(date +%Y%m%d) .
cd ../
cd ./docs
docker build --build-arg parent_image=$(whoami)/base_${build_type}_$(uname -m):$(date +%Y%m%d) \
    -t $(whoami)/docs_$(uname -m):$(date +%Y%m%d) .
cd ../
```

## Recommennded extensions
Once you are attached to a container, you can install extensions inside. Extensions are bound to iamge names, 
the next time you start the image, all the previously installed extensions will be installed on startup.
You can check this list: CMD + SHIFT + P -> 'Dev Containers: Open Attached Container Configuration File' 

### General
- eamodio.gitlens
    * Inline git blame, git hist
    * Commit graph
- zxh404.vscode-proto3
    * proto file language support
### C++
- ms-vscode.cpptools
- twxs.cmake
    * CMake language support
- matepek.vscode-catch2-test-adapter
    * test runner
### Java
- redhat.java
    * language support
    * probably need to add `java/**/bin` to your gitignore
- vscjava.vscode-java-debug
    * debugger
- vscjava.vscode-java-test
    * test runner
### Python
- ms-python.python
