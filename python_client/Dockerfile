ARG parent_image
from ${parent_image}

WORKDIR /apache/dev/git/kudu/build/debug
RUN ninja

WORKDIR /apache/dev/git/kudu

RUN apt update -y
RUN apt install software-properties-common -y
RUN add-apt-repository ppa:deadsnakes/ppa
RUN apt install python3.7 python3.7-dev \
python3-distutils \
-y
RUN update-alternatives --install /usr/bin/python python /usr/bin/python3.7 1
RUN update-alternatives --install /usr/bin/python python /usr/bin/python2.7 1

RUN update-alternatives --set python /usr/bin/python2.7
RUN ./docker/bootstrap-python-env.sh
RUN pip install virtualenv

RUN update-alternatives --set python /usr/bin/python3.7
RUN ./docker/bootstrap-python-env.sh
RUN pip install virtualenv

COPY build.sh build.sh
COPY switch.sh switch.sh
COPY pre_gerrit.sh pre_gerrit.sh
COPY start_kudu.sh start_kudu.sh
COPY stop_kudu.sh stop_kudu.sh

WORKDIR /apache/dev/git/kudu/python

