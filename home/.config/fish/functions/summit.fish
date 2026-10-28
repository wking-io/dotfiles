function summit
    rm -rf ./.overmind.sock
    source ~/.config/fish/config.fish
    pyenv local summit
    overmind start -f Procfile.dev
end
