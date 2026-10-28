function fvim
    if test (count $argv) -eq 0
        fd -H -t f | fzf --header "Open File in Vim" --preview "cat {}" | xargs nvim
    else
        set -l query (string join " " $argv)
        fd -H -t f | fzf --header "Open File in Vim" --preview "cat {}" -q "$query" | xargs nvim
    end
end
