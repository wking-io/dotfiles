function gbda -d "Delete all branches merged in current HEAD, including squashed"
  set -l default_branch (__git.default_branch)
  set -l default_sha (git rev-parse $default_branch)
  set -l candidates

  # Regular merges. Skip the current/worktree branches, long-lived branches, and
  # branches whose tip equals the default branch (fresh branches with no commits).
  for branch in (git branch --merged | command grep -vE '^\*|^\+' | string trim)
    contains -- $branch master main develop $default_branch; and continue
    test (git rev-parse $branch) = $default_sha; and continue
    set -a candidates $branch
  end

  # Squash merges.
  for branch in (git for-each-ref refs/heads/ "--format=%(refname:short)")
    contains -- $branch master main develop $default_branch $candidates; and continue
    test (git rev-parse $branch) = $default_sha; and continue
    set -l merge_base (git merge-base $default_branch $branch)
    if string match -q -- '-*' (git cherry $default_branch (git commit-tree (git rev-parse $branch\^{tree}) -p $merge_base -m _))
      set -a candidates $branch
    end
  end

  if test (count $candidates) -eq 0
    echo "No merged branches to delete."
    return 0
  end

  printf '  %s\n' $candidates
  read -l -P "Delete these "(count $candidates)" branches? [y/N] " confirm
  string match -qi 'y*' -- $confirm; or return 1

  for branch in $candidates
    git branch -D $branch
  end
end
