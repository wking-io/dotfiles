function switch_php
    # Platform-specific PHP switching
    # macOS: Switch between Homebrew PHP and Herd PHP
    # Linux: Switch between system PHP and custom PHP installations

    switch (uname)
        case Darwin
            # macOS paths
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

        case Linux
            # Linux: typically system PHP is at /usr/bin/php
            # Custom PHP might be at /opt/php or ~/.local/bin
            set -l systemPath "/usr/bin"
            set -l customPath "$HOME/.local/bin"

            set -l newPATH
            for dir in $PATH
                if test "$dir" != $systemPath -a "$dir" != $customPath
                    set newPATH $newPATH $dir
                end
            end

            switch $argv[1]
                case system
                    set -gx PATH $systemPath $newPATH
                    echo "Switched to System PHP: (which php) returns" (which php)
                case custom
                    set -gx PATH $customPath $newPATH
                    echo "Switched to Custom PHP: (which php) returns" (which php)
                case '*'
                    echo "Usage: switch_php [system|custom]"
            end

        case '*'
            echo "Unsupported platform"
    end
end
