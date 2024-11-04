set -x LANG en_US.UTF-8

# ALIASES
alias gs="git status"
alias gch="git checkout"
alias gcb="git checkout -b"
alias gc="git commit -m"
alias gaa="git add -A"
alias a="php artisan"
alias python="python3"
alias p="pnpm"
alias sc="cd ~/sites/crunchy/"
alias sp="cd ~/sites/projects/"

source ~/.asdf/asdf.fish

# Initialize pyenv
status --is-interactive; and pyenv init - | source

# Initialize pyenv-virtualenv
pyenv virtualenv-init - | source

# pnpm
set -gx PNPM_HOME /Users/wking/Library/pnpm
if not string match -q -- $PNPM_HOME $PATH
    set -gx PATH "$PNPM_HOME" $PATH
end
# pnpm end

set -gx GOPATH $HOME/go
set -gx PATH $GOPATH/bin /usr/local/go/bin $PATH
