function switch_php
    # Define the two PHP installation directories.
    set -l brewPath "/opt/homebrew/opt/php@8.3/bin"
    set -l herdPath "$HOME/Library/Application Support/Herd/bin/php"
    
    # Build a new PATH by filtering out any existing brew or herd entries.
    set -l newPATH
    for dir in $PATH
        if test "$dir" != $brewPath -a "$dir" != $herdPath
            set newPATH $newPATH $dir
        end
    end

    # Determine which PHP to use.
    switch $argv[1]
        case brew
            set -gx PATH $brewPath $newPATH
            echo "Switched to Brew PHP: (which php) returns" (which php)
        case herd
            set -gx PATH $herdPath $newPATH
            echo "Switched to Herd PHP: (which php) returns" (which php)
        case '*'
            echo "Usage: switch_php [brew|herd]"
    end
end
