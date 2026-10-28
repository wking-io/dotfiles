function freshignore
    git rm -r --cached .
    git add .
    git commit -am "Removed ignored files"
end
