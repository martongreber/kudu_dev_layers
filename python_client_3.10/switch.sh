# update-alternatives --config python
if [ $1 == 2 ]; then
    version="python2.7"
    echo "Switching python version to $version"
    update-alternatives --set python /usr/bin/$version
fi
if [[ $1 =~ ^3\..*$ ]]; then
    version="python$1"
    echo "Switching Python version to $version"
    update-alternatives --set python /usr/bin/$version
fi

