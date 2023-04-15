# Kudu dev layers base image

## Usage
* Add any configuration, script etc. into this folder to include it in all other layers
* The base image has 3 args:
    - username: your github username, necessary to set the Kudu repo remote, and setup gerrit
    - parent_image: the root image name (murculus/kudu-debug etc.)
    - arch: which arch to pull