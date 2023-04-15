# Developing C++ client example
## Usage
1. In $KUDU_HOME execute setup_example.sh
    * This whill install the client example to /tmp/...
1. Go to $CLIENT_APP_DIR 
1. Run make.sh to build the example client application
1. Run test.sh:
    * this will stop the running Kudu cluster
    * build the client application
    * start the Kudu cluster (wait for it to setup)
    * execute the client application
1. If everythin is good you need to sync your changes to $KUDU_HOME to be able to commit it:
    * run sync.sh 
    * if you added a new file, obviously extend sync.sh with it

