PROMPT='$fg_bold[blue]$(get_pwd) $reset_color$(git_prompt_info)
$reset_color▲ '

ZSH_THEME_GIT_PROMPT_PREFIX="%{$fg[cyan]%}["
ZSH_THEME_GIT_PROMPT_SUFFIX="%{$reset_color%} "
ZSH_THEME_GIT_PROMPT_DIRTY="%{$fg[cyan]%}] %{$fg[magenta]%} ಠ_ಠ"
ZSH_THEME_GIT_PROMPT_CLEAN="%{$fg[cyan]%}]"

function get_pwd() {
  echo "${PWD/$HOME/~}"
}
