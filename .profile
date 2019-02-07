export PATH=/usr/local/bin:$PATH       # ensure user-installed binaries take precedence

# COMPLETIONS
export BASH_COMPLETION_COMPAT_DIR="/opt/homebrew/etc/bash_completion.d"
# source $BASH_COMPLETION_COMPAT_DIR/*   # load all completions

test -f ~/.bashrc && source ~/.bashrc  # load .bashrc if it exists
