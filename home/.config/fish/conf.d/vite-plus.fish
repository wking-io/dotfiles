# Vite+ environment setup (https://viteplus.dev)
#
# Vite+ installs to ~/.local/share/vite-plus and generates
# ~/.config/vite-plus/env.fish. That file eagerly runs `vp` at startup to
# register completions, so only its PATH setup and `vp env use` wrapper are
# mirrored here; completions/vp.fish and completions/vpr.fish load lazily.
set -l __vp_bin "$HOME/.local/share/vite-plus/bin"
set -l __vp_fallback "$HOME/.local/share/vite-plus/fallback-bin"
for __vp_dir in $__vp_bin $__vp_fallback
    while set -l __vp_idx (contains -i -- $__vp_dir $PATH)
        set -e PATH[$__vp_idx]
    end
end
set -gx PATH $__vp_bin $PATH $__vp_fallback

function vp --description "Run Vite+ and apply `vp env use` changes to this shell"
    set -l __vp_command_index 1
    if test (count $argv) -ge 1
        if test "$argv[1]" = "-C"
            set __vp_command_index 3
        else if string match -qr '^-C.+' -- "$argv[1]"
            set __vp_command_index 2
        end
    end
    set -l __vp_next_index (math $__vp_command_index + 1)

    if test (count $argv) -ge $__vp_next_index; and test "$argv[$__vp_command_index]" = "env"; and test "$argv[$__vp_next_index]" = "use"
        if contains -- -h $argv; or contains -- --help $argv
            command vp $argv; return
        end
        set -lx VP_ENV_USE_EVAL_ENABLE 1
        set -lx VP_SHELL fish
        set -l __vp_out (command vp $argv); or return $status
        for __vp_command in $__vp_out
            eval $__vp_command; or return $status
        end
        return 0
    else
        command vp $argv
    end
end
