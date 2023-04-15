ARG parent_image
from ${parent_image}

WORKDIR /apache/dev/git/kudu/build/latest
RUN ninja

WORKDIR /apache/dev/git/kudu
COPY setup_example.sh setup_example.sh

# setup cpp client working dir
WORKDIR /apache/dev/git/kudu/build/latest
RUN DESTDIR=/tmp/client_alt_root ninja install
WORKDIR /tmp/client_alt_root/usr/local/share/doc/kuduClient/examples

COPY start_kudu.sh start_kudu.sh
COPY stop_kudu.sh stop_kudu.sh
COPY make.sh make.sh
COPY test.sh test.sh
COPY sync.sh sync.sh

RUN echo "export CLIENT_APP_DIR=/tmp/client_alt_root/usr/local/share/doc/kuduClient/examples" >> /root/.bashrc