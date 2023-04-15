ARG username
ARG arch=x86_64
ARG root_image=murculus/kudu-debug
from ${root_image}:${arch}

# Set remote to your repository
WORKDIR /apache/dev/git/kudu
RUN git remote set-url origin git@github.com:$username/kudu.git

# Gerrit bootstrap
RUN git remote add gerrit ssh://$username@gerrit.cloudera.org:29418/kudu

RUN gitdir=$(git rev-parse --git-dir) && \
curl -LSsf https://gerrit.cloudera.org/tools/hooks/commit-msg -o ${gitdir}/hooks/commit-msg && \
chmod +x ${gitdir}/hooks/commit-msg

RUN git config branch.autosetuprebase always
RUN git config branch.master.rebase true
# The .bashrc down below provides an alias gpg (Git Push Gerrit)

# Setup your desired dotfiles
WORKDIR /root
COPY .bashrc .bashrc
COPY .bash_profile .bash_profile

# Install any package necessary
RUN apt update -y
RUN apt install tmux \
-y

WORKDIR /apache/dev/git/kudu