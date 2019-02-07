# ~/.bashrc: executed by bash for non-login shells
# DEPS: /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
# DEPS: brew install bash-completion bash-git-prompt bat exa fzf meld node nvm yarn

# DEFAULTS & SHORTCUTS
export BASH_SILENCE_DEPRECATION_WARNING=1
export CDPATH=.:..:~
export GIT_PS1_SHOWDIRTYSTATE=true # add an asterisk to branch name if it has changed
# export GREP_OPTIONS='--color -b1'
alias '..'='cd ..'
alias ...='cd ../..'
alias ....='cd ../../../'
alias .5='cd ../../../../..'
alias cat='bat --pager=never'
alias c='open -b com.microsoft.VSCode "$@"'
function dif() { diff $1 $2 | bat ;}
alias l='exa'
alias la='exa -a'
alias ll='exa -lah --git'
alias ls='exa --color=auto'
alias g='git'
alias gc='gh copilot suggest -t shell "Kill processes holding onto deleted files"'
alias ytags='y info <package-name> version'
function _gh() { open https://github.$(git config remote.origin.url | cut -f2 -d. | tr ':' /)/$1$2$3 ;}
alias ghb='_gh tree/$(git symbolic-ref --quiet --short HEAD )/$(git rev-parse --show-prefix)'
alias ghf='ghb $(git rev-parse --show-prefix && git rev-parse --short HEAD)/'
alias ghfr='ghb $(git rev-parse --short HEAD)/'
function gtop() { git log --since ${1-6.months}.ago --name-only --pretty=format: | sed "/^\s*$/"d | grep -v ".*\.\(json\|lock\|snap\)$" | sort | uniq -c | sort -nr | head -n 25 ;}
alias jira='open https://ORG.atlassian.net/browse/$(git symbolic-ref --quiet --short HEAD )/$(git rev-parse --show-prefix)'
alias y='yarn'
alias yb='y build'
alias ybs='yb; yss'
alias yd='y dev'
alias yf='y --force'
alias yl='y lint --cache'
alias ylf='y lint:fix --cache'
function ylink() { y link $1 ;}
function yls() { ll "node_modules/$1" ;}
function ycat() { cat "node_modules/$1/${2-package.json}" ;}
alias ys='y start'
alias yss='y serve'
alias yt='y test'
alias ytu='y test:u'
alias ytc='y test:coverage'
alias ytt='y check:types'

# BREW
# export BREW_DIR=$(brew --prefix)
export BREW_DIR="/opt/homebrew"
eval "$($BREW_DIR/bin/brew shellenv)"   # load env vars

# GO
# export GOPATH="$HOME/.GO"

# GIT
if ! shopt -oq posix; then\
  # in interactive shells
  if [ -r $BREW_DIR/etc/profile.d/bash_completion.sh ]; then
    source $BREW_DIR/etc/profile.d/bash_completion.sh
    __git_complete g _git
  fi

  if [ -f "$BREW_DIR/opt/bash-git-prompt/share/gitprompt.sh" ]; then
    __GIT_PROMPT_DIR="$BREW_DIR/opt/bash-git-prompt/share"
    source "$BREW_DIR/opt/bash-git-prompt/share/gitprompt.sh"
  fi
fi
export PS1='\[\e[32m\][\u@\h] \[\e[33m\w\]\n\[\e[1;34m\][\t]\[\e[0m\]\[\e[0;36m\]$(__git_ps1 " (%s)")\[\e[0m\] $ '

# K8S
# export PS1='$(kube_ps1)'$PS1
# source "/usr/local/opt/kube-ps1/share/kube-ps1.sh"
# source <(kubectl completion bash)
# alias k='kubectl'
# alias kc='k config use-context'
# alias kgp='k get pods'
# alias kgf='k get pods | grep'
# function kdc() {
#   local ns=$1
#   local deployment=$2
#   local openBrowserFlag=$3
#   local commitHash=$(k get deployments --namespace $ns --output=jsonpath='{.spec.template.metadata.labels.commitHash}' $deployment | cut -d- -f2)
#   if [ -z "$commitHash" ]; then
#     echo "Error: commit hash not found. Please check context, namepace and deployment names."
#   else
#     local possibleBranch=$(git branch --contains "$commitHash" --format='%(refname:short)' | head -n 1)
#     local baseUrl="https://github.com/ORG/$deployment/commits"
#     local url="$baseUrl/$commitHash"
#     echo "Deployed commit: $commitHash ($deployment @ [${possibleBranch:-unknown}])"
#     [ -n "$openBrowserFlag" ] && echo "Opening commit in browser: $url" && open "$url"
#   fi
# }
# function kcommit() {
#   local ns=$1
#   local deployment=$2
#   local openBrowserFlag=$3
#   local commitHash=$(k get deployments --namespace $ns --output=jsonpath='{.spec.template.metadata.labels.commitHash}' $deployment | cut -d- -f2)
#   if [ -z "$commitHash" ]; then
#     echo "Error: commit hash not found. Please check context, namepace and deployment names."
#   else
#     local possibleBranch=$(git branch --contains "$commitHash" --format='%(refname:short)' | head -n 1)
#     local baseUrl="https://github.com/ORG/$deployment/commits"
#     local url="$baseUrl/$commitHash"
#     echo "Deployed commit: $commitHash ($deployment @ [${possibleBranch:-unknown}])"
#     [ -n "$openBrowserFlag" ] && echo "Opening commit in browser: $url" && open "$url"
#   fi
# }

# HISTORY
export HISTCONTROL=ignoreboth    # avoid duplicate lines in history
export PROMPT_COMMAND="history -a; history -n; ${PROMPT_COMMAND}"    # sync bash memory and history file
shopt -s histappend              # update history after command execution instead of on session end
[ -f ~/.fzf.bash ] && source ~/.fzf.bash

# NVM
export NVM_DIR="$HOME/.nvm"
[ -s "$BREW_DIR/opt/nvm/nvm.sh" ] && \. "$BREW_DIR/opt/nvm/nvm.sh"
[ -s "$BREW_DIR/opt/nvm/etc/bash_completion.d/nvm" ] && \. "$BREW_DIR/opt/nvm/etc/bash_completion.d/nvm"

# PYTHON
# export LANG=en_US.UTF-8     # avoid OSX UTF-8 ValueError
# export LC_ALL=en_US.UTF-8   # avoid OSX UTF-8 ValueError
# export PROJECT_HOME=$HOME/Projects
# export VIRTUALENVWRAPPER_PYTHON=/usr/local/bin/python3
# export WORKON_HOME=$HOME/.virtualenvs
# source /usr/local/bin/virtualenvwrapper.sh

# UTILS
function dt() { date -r $(($1/100)) ;}
function perf() { time for ((i=0; i<3; i++)) { $* ;} ;}
depcruiser() {
    yarn dependency-cruiser \
      --output-type dot ${1:-.} --collapse=${2:-2} --focus="${3:-.*}" --metrics \
      --exclude "(^node_modules.*|.*index.tsx?|^e2e|^migrations|.*\\.(spec|test|snap)\\.tsx?)" | sed '1,2d;$d'
}
function hdeps() { depcruiser $* | dot -T svg | yarn depcruise-wrap-stream-in-html | sed '1,2d;$d' > dependencies.html && open -b com.google.Chrome -- dependencies.html ;}
function cdeps() { depcruiser $* | dot -T svg | yarn depcruise-wrap-stream-in-html | sed '1,2d;$d' | open -b com.google.Chrome -- "data:text/html;base64,$(base64)" ;}

alias weather='curl http://wttr.in'
