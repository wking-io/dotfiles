#######################
####   FUNCTIONS   ####
#######################

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


#######################
####    ALIASES    ####
#######################

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