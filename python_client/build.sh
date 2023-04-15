#!/bin/bash

BUILD_TYPE=${BUILD_TYPE:-DEBUG}
BUILD_TYPE=$(echo "$BUILD_TYPE" | tr a-z A-Z) # capitalize
BUILD_TYPE_LOWER=$(echo "$BUILD_TYPE" | tr A-Z a-z)

SOURCE_ROOT=$(cd $(dirname "$BASH_SOURCE"); pwd)
BUILD_ROOT=$SOURCE_ROOT/build/$BUILD_TYPE_LOWER

CLANG=$(pwd)/build-support/ccache-clang/clang


# Failing to compile the Python client should result in a build failure.
set -e
export KUDU_HOME=$SOURCE_ROOT
export KUDU_BUILD=$BUILD_ROOT
pushd $SOURCE_ROOT/python


setup_env_3() {
    # Create a sane test environment.
    rm -Rf $KUDU_BUILD/py_env
    virtualenv -p python3 $KUDU_BUILD/py_env
    source $KUDU_BUILD/py_env/bin/activate

    # Old versions of pip (such as the one found in el6) default to pypi's http://
    # endpoint which no longer exists. The -i option lets us switch to the
    # https:// endpoint in such cases.
    #
    # Unfortunately, in these old versions of pip, -i doesn't appear to apply
    # recursively to transitive dependencies installed via a direct dependency's
    # "python setup.py" command. Therefore we have no choice but to upgrade to a
    # new version of pip to proceed.
    #
    # pip 19.1 doesn't support Python 3.4, which is the version of Python 3
    # shipped with Ubuntu 14.04. However, there appears to be a bug[1] in pip 19.0
    # preventing it from working properly with Python 3.4 as well. Therefore we
    # must pin to a pip version from before 19.0.
    #
    # The absence of $PIP_FLAGS is intentional: older versions of pip may not
    # support the flags that we want to use.
    #
    # 1. https://github.com/pypa/pip/issues/6175
    pip install -i https://pypi.python.org/simple $PIP_INSTALL_FLAGS --upgrade 'pip'

    # New versions of pip raise an exception when upgrading old versions of
    # setuptools (such as the one found in el6). The workaround is to upgrade
    # setuptools on its own, outside of requirements.txt, and with the pip version
    # check disabled.
    pip $PIP_FLAGS install --disable-pip-version-check $PIP_INSTALL_FLAGS --upgrade 'setuptools'

    # One of our dependencies is pandas, installed below. It depends on numpy, and
    # if we don't install numpy directly, the pandas installation will install the
    # latest numpy which is incompatible with Python 3.4 (the version of Python 3
    # shipped with Ubuntu 14.04).
    #
    # To work around this, we need to install a 3.4-compatible version of numpy
    # before installing pandas. Installing numpy may involve some compiler work,
    # so we must pass in the current values of CC and CXX.
    #
    # See https://github.com/numpy/numpy/releases/tag/v1.16.0rc1 for more details.
    CC=$CLANG CXX=$CLANG++ pip $PIP_FLAGS install $PIP_INSTALL_FLAGS 'numpy'

    # We've got a new pip and new setuptools. We can now install the rest of the
    # Python client's requirements.
    #
    # Installing the Cython dependency may involve some compiler work, so we must
    # pass in the current values of CC and CXX.
    CC=$CLANG CXX=$CLANG++ pip $PIP_FLAGS install $PIP_INSTALL_FLAGS -r requirements.txt

    # We need to install Pandas manually because although it's not a required
    # package, it is needed to run all of the tests.
    #
    # Installing pandas may involve some compiler work, so we must pass in the
    # current values of CC and CXX.
    CC=$CLANG CXX=$CLANG++ pip $PIP_FLAGS install $PIP_INSTALL_FLAGS pandas

    # Delete old Cython extensions to force them to be rebuilt.
    rm -Rf build kudu_python.egg-info kudu/*.so
    deactivate
}

build_bindings_3(){ 
    source $KUDU_BUILD/py_env/bin/activate

    # Build the Python bindings. This assumes we run this script from base dir.
    CC=$CLANG CXX=$CLANG++ python setup.py build_ext
    set +e

    # Run the Python tests. This may also involve some compiler work.
    if ! CC=$CLANG CXX=$CLANG++ python setup.py test \
        --addopts="kudu --junit-xml=$TEST_LOGDIR/python3_client.xml" \
        2> $TEST_LOGDIR/python3_client.log ; then
    TESTS_FAILED=1
    FAILURES="$FAILURES"$'Python 3 tests failed\n'
    fi

    deactivate
}


setup_env_2() {
       # Create a sane test environment.
    rm -Rf $KUDU_BUILD/py_env
    virtualenv $KUDU_BUILD/py_env

    source $KUDU_BUILD/py_env/bin/activate

    # Old versions of pip (such as the one found in el6) default to pypi's http://
    # endpoint which no longer exists. The -i option lets us switch to the
    # https:// endpoint in such cases.
    #
    # Unfortunately, in these old versions of pip, -i doesn't appear to apply
    # recursively to transitive dependencies installed via a direct dependency's
    # "python setup.py" command. Therefore we have no choice but to upgrade to a
    # new version of pip to proceed.
    #
    # Beginning with pip 10, Python 2.6 is no longer supported. Attempting to
    # upgrade to pip 10 on Python 2.6 yields syntax errors. We don't need any new
    # pip features, so let's pin to the last pip version to support Python 2.6.
    #
    # The absence of $PIP_FLAGS is intentional: older versions of pip may not
    # support the flags that we want to use.
    pip install -i https://pypi.python.org/simple $PIP_INSTALL_FLAGS --upgrade 'pip <10.0.0b1'

    # New versions of pip raise an exception when upgrading old versions of
    # setuptools (such as the one found in el6). The workaround is to upgrade
    # setuptools on its own, outside of requirements.txt, and with the pip version
    # check disabled.
    #
    # Setuptools 42.0.0 changes something that causes build_ext to fail with a
    # missing wheel package. Let's pin to an older version known to work.
    pip $PIP_FLAGS install --disable-pip-version-check $PIP_INSTALL_FLAGS --upgrade 'setuptools >=0.8,<42.0.0'

    # One of our dependencies is pandas, installed below. It depends on numpy, and
    # if we don't install numpy directly, the pandas installation will install the
    # latest numpy which is incompatible with Python 2.6.
    #
    # To work around this, we need to install a 2.6-compatible version of numpy
    # before installing pandas. Installing numpy may involve some compiler work,
    # so we must pass in the current values of CC and CXX.
    #
    # See https://github.com/numpy/numpy/releases/tag/v1.12.0 for more details.
    CC=$CLANG CXX=$CLANG++ pip $PIP_FLAGS install $PIP_INSTALL_FLAGS 'numpy <1.12.0'

    # We've got a new pip and new setuptools. We can now install the rest of the
    # Python client's requirements.
    #
    # Installing the Cython dependency may involve some compiler work, so we must
    # pass in the current values of CC and CXX.
    CC=$CLANG CXX=$CLANG++ pip $PIP_FLAGS install $PIP_INSTALL_FLAGS -r requirements.txt

    # We need to install Pandas manually because although it's not a required
    # package, it is needed to run all of the tests.
    #
    # Installing pandas may involve some compiler work, so we must pass in the
    # current values of CC and CXX.
    #
    # pandas 0.18 dropped support for python 2.6. See https://pandas.pydata.org/pandas-docs/version/0.23.0/whatsnew.html#v0-18-0-march-13-2016
    # for more details.
    CC=$CLANG CXX=$CLANG++ pip $PIP_FLAGS install $PIP_INSTALL_FLAGS 'pandas <0.18'

    # Delete old Cython extensions to force them to be rebuilt.
    rm -Rf build kudu_python.egg-info kudu/*.so
    deactivate
}

build_bindings_2(){ 
    source $KUDU_BUILD/py_env/bin/activate

    # Build the Python bindings. This assumes we run this script from base dir.
    CC=$CLANG CXX=$CLANG++ python setup.py build_ext
    set +e

    # Run the Python tests. This may also involve some compiler work.
    if ! CC=$CLANG CXX=$CLANG++ python setup.py test \
        --addopts="kudu --junit-xml=$TEST_LOGDIR/python_client.xml" \
        2> $TEST_LOGDIR/python_client.log ; then
    TESTS_FAILED=1
    FAILURES="$FAILURES"$'Python tests failed\n'
    fi

    deactivate
}


if [ $1 == "3" ]; then
    $KUDU_HOME/switch.sh 3
    echo
    echo Building and testing python 3.
    echo ------------------------------------------------------------
    setup_env_3
    build_bindings_3
fi
if [ $1 == "2" ]; then
    $KUDU_HOME/switch.sh 2
    echo
    echo Building and testing python 2.
    echo ------------------------------------------------------------
    setup_env_2
    build_bindings_2
fi