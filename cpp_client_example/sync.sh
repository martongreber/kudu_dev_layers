
sync() {
    dir=$KUDU_HOME/examples/cpp
    rsync ./$1 $dir/$1
}

sync CMakeLists.txt
sync example.cc
sync non_unique_primary_key.cc