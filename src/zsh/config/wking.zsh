# Function to install peer deps in an npm package
# ▲ installPeer package
# ▲ installPeer devPackage -dev
function installPeer () {
  export PKG=$1;
  npm info "$PKG" peerDependencies --json | command sed 's/[\{\},]//g ; s/: /@/g' | xargs npm install --save"$2" "$PKG"
}
