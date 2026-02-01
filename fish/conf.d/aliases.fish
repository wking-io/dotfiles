alias c 'clear'
alias code 'vim'
alias gs 'git status'
alias gch 'git checkout'
alias gcb 'git checkout -b'
alias gc 'git commit -m'
alias gaa="git add -A"
alias grep 'grep --color=auto --exclude-dir={.bzr,CVS,.git,.hg,.svn,.idea,.tox}'
alias ks 'tmux kill-server'

# Cross-platform clipboard aliases
if type -q pbcopy
    # macOS
    alias pbc 'pbcopy'
    alias pbp 'pbpaste'
else if type -q xclip
    # Linux with xclip
    alias pbc 'xclip -selection clipboard'
    alias pbp 'xclip -selection clipboard -o'
else if type -q xsel
    # Linux with xsel
    alias pbc 'xsel --clipboard --input'
    alias pbp 'xsel --clipboard --output'
else if type -q wl-copy
    # Wayland
    alias pbc 'wl-copy'
    alias pbp 'wl-paste'
end

alias oc 'opencode'
# Disable automatic completion generation for oc to avoid errors
complete -c oc -e
alias vimdiff 'nvim -d'
alias wr 'wrangler'
alias a 'php artisan'
alias p 'pnpm'
alias td 'tmux detach'
alias ta 'tmux attach'
alias cc 'claude --dangerously-skip-permissions'
