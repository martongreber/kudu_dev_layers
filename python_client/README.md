# Python client development
## Usage
* use build.sh 3 or build.sh 2 in $KUDU_HOME to setup the build environment and also start the tests
* afther using build.sh, the env for the give Python version is complete
    * further builds can be done in $KUDU_HOME/python with: python setup.py build_ext
    * running tests in $KUDU_HOME/python: python setup.py test
    * you can also run pre_gerrit.sh from $KUDU_HOME, which will build and test for Python 2 and 
    Python 3