bindkey '^[[H' beginning-of-line                                # Home key
bindkey '^[[F' end-of-line                                      # End key
bindkey '^?' backward-delete-char                               # Backspace key
bindkey '^[[3~' delete-char                                     # Delete key

# Navigate words with ctrl+arrow keys
bindkey '^[Oc' forward-word                                     #
bindkey '^[Od' backward-word                                    #
bindkey '^[[1;5D' backward-word                                 #
bindkey '^[[1;5C' forward-word                                  #
bindkey '^H' backward-kill-word                                 # delete previous word with ctrl+backspace
bindkey '^[[Z' undo                                             # Shift+tab undo last action

if [[ -n "$NVIM" || -n "$NVIM_LISTEN_ADDRESS" ]]; then
  alias nvim=nvr -cc split --remote-wait +'set bufhidden=wipe'
  export VISUAL="nvr -cc split --remote-wait +'set bufhidden=wipe'"
  export EDITOR="nvr -cc split --remote-wait +'set bufhidden=wipe'"
else
  export VISUAL="nvim"
  export EDITOR="nvim"
fi

# Git
function squash() {
  git rebase --interactive HEAD~$1 ${@:2} --autostash
}

function ctime() {
  GIT_COMMITTER_DATE="`date -d $1`" git commit --date "`date -d $1` ${@:2}"
}

function pickup() {
  git reset "HEAD^${1:=1}" --soft
}

function pp() {
  BRANCH=`git branch | grep \* | cut -d ' ' -f2`
  git push -u origin "$BRANCH" $@
}

function rebase() {
  CURRENT_BRANCH=`git branch | grep \* | cut -d ' ' -f2`
  BRANCH=${1:=$CURRENT_BRANCH}
  git fetch origin
  git rebase "origin/$BRANCH" --autostash ${@:2}
}
function rebase-only() {
  CURRENT_BRANCH=`git branch | grep \* | cut -d ' ' -f2`
  BRANCH=${1:=$CURRENT_BRANCH}
  git rebase "origin/$BRANCH" --autostash ${@:2}
}
function rebase-onto() {
  CURRENT_BRANCH=`git branch | grep \* | cut -d ' ' -f2`
  BRANCH=$1
  COUNT=$2
  git fetch origin
  git rebase --autostash --rebase-merges --onto "$BRANCH" "$CURRENT_BRANCH"~$COUNT "$CURRENT_BRANCH" ${@:3}
}

alias cont="git rebase --continue"
alias amend="git commit --amend"
alias force="git push --force-with-lease"
alias p="git push"
alias a="git add"
alias s="git status"
alias c="git commit"
alias co="git checkout"
alias pr="hub pull-request"
alias fa="git fetch --all"

function which-port {
  netstat -tunapl | grep $1
}

if command -v xdg-open &> /dev/null; then
  alias open='xdg-open'
fi

# Rust
export PATH="$HOME/.cargo/bin:$PATH"

# Javascript

export PATH="$PATH:./node_modules/.bin"
NPM_PACKAGES="$HOME/.npm-packages"
export PATH="$PATH:$NPM_PACKAGES/bin"
alias nup="$NPM_PACKAGES/bin/nu"

# React Native

function devmenu() {
  adb shell input keyevent 82
}

function bundleip() {
  adb shell input text `ip`:8081
  adb shell input keyevent 111
}

# MacOS
test -e "${HOME}/.iterm2_shell_integration.zsh" && source "${HOME}/.iterm2_shell_integration.zsh"
