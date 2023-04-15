set -e
cmake -G "Unix Makefiles" -DkuduClient_DIR=/tmp/client_alt_root/usr/local/share/kuduClient/cmake -DCMAKE_BUILD_TYPE=debug
make