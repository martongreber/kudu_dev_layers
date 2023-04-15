set -o vi

export KUDU_HOME=/apache/dev/git/kudu

# prompt config
# display git branch name
parse_git_branch() {
     git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/ (\1)/'
}
export PS1="\u@\h \[\033[32m\]\w\[\033[33m\]\$(parse_git_branch)\[\033[00m\] $ "

source /usr/share/bash-completion/completions/git

alias gpg="git push gerrit HEAD:refs/for/master --no-thin"