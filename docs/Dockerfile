# gh pages recommended install
# https://tecadmin.net/installing-ruby-on-ubuntu-debian/ as ruby 2.6 is not installable by default through apt
ARG parent_image
from ${parent_image}

ARG DEBIAN_FRONTEND=noninteractive
RUN apt update
RUN apt install libxslt-dev \
libxml2-dev \
zip \
xsltproc \
curl \
gnupg2 \
-y

RUN curl -sSL https://rvm.io/mpapis.asc | sudo gpg2 --import - 
RUN curl -sSL https://rvm.io/pkuczynski.asc | sudo gpg2 --import -
RUN curl -sSL https://get.rvm.io | sudo bash -s stable 
RUN /bin/bash -c "source /etc/profile.d/rvm.sh && \
rvm requirements && \
rvm install 2.6 && \
rvm use 2.6 --default"
RUN echo "source /etc/profile.d/rvm.sh" >> /root/.bashrc

WORKDIR /apache/dev/git/kudu
# RUN ./docs/support/scripts/make_site.sh --no-doxygen --no-javadoc --force