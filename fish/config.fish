set -x LANG en_US.UTF-8

fish_vi_key_bindings

set -gx EDITOR (which nvim)
set -gx VISUAL $EDITOR
set -gx SUDO_EDITOR $EDITOR

# EDITOR
abbr vim nvim
abbr vi nvim
abbr v nvim

# ALIASES
alias gs="git status"
alias gch="git checkout"
alias gcb="git checkout -b"
alias gc="git commit -m"
alias gaa="git add -A"
alias a="php artisan"
alias python="python3"
alias p="pnpm"
alias sc="cd ~/Developer/crunchy/"
alias sp="cd ~/Developer/projects/"
alias td="tmux detach"
alias ta="tmux attach"

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
set -gx PATH /Users/wking/.cache/rebar3/bin $PATH
zoxide init fish | source
fzf --fish | source
