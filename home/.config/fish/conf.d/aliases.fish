alias c 'clear'
alias code 'nvim'
alias gs 'git status'
alias gch 'git checkout'
alias grep 'grep --color=auto --exclude-dir={.bzr,CVS,.git,.hg,.svn,.idea,.tox}'
alias pbc 'pbcopy'
alias pbp 'pbpaste'
alias vimdiff 'nvim -d'
alias wr 'wrangler'
alias p 'pnpm'
alias pn 'pnpm'

# Cloudflare OpenCode: log in to the internal gateway + cf-portal MCP, then start
alias oc 'clear && opencode auth login https://opencode.cloudflare.dev && opencode mcp auth cf-portal && opencode'
# Disable automatic completion generation for oc to avoid errors
complete -c oc -e
# Jump to the stratus repo and start OpenCode
alias ocs 'cd $HOME/Developer/work/stratus && oc'
complete -c ocs -e

# Vite+ manages Node; route one-off package runners through it
alias bunx 'vpx'
alias npx 'vpx'
alias codex 'pi'
