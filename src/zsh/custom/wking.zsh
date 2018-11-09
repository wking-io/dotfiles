# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

# FUNCTIONS

# Function to install peer deps in an npm package
# ▲ installPeer package
# ▲ installPeer devPackage -dev
function installPeer () {
  export PKG=$1;
  npm info "$PKG" peerDependencies --json | command sed 's/[\{\},]//g ; s/: /@/g' | xargs npm install --save"$2" "$PKG"
}

# Make directory and change into it.
function mcd() {
  mkdir -p "$1" && cd "$1";
}

# https://twitter.com/wesbos/status/601426471240998912
function t() {
 tree -I '.git|node_modules|bower_components|.DS_Store' --dirsfirst --filelimit 15 -L ${1:-3} -aC $2
}

# undo push to passed in branch
# ▲ undopush development
function undopush() {
    git push -f origin HEAD^:$1
}

# undo push to passed in branch
# ▲ undopush development
function freshignore() {
    git rm -r --cached .
    git add .
    git commit -am "Removed ignored files"
}

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

# ALIASES

# GIT aliases
alias gs="git status"
alias gch="git checkout"
alias gcb="git checkout -b"
alias gc="git commit -m"
alias gaa="git add -A"
alias ga="git add"
alias gd="git diff"
alias gc-="git checkout -- ."
alias gr="git reset --hard HEAD"
alias master="git checkout master"

# Shortcut for making and unmaking files executable
alias chmoz='chmod +x'
alias chmox='chmod -x'

# Open hosts file in vscode
alias hosts='sudo code /etc/hosts'

# File size
alias fs="stat -f \"%z bytes\""
