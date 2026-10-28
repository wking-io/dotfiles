# gtest: test a command against git staged changes.
#
# example usage:
#   gtest make test
function gtest -d "test command on staged changes only"
  # Stash working dir, keeping index changes. Only pop later if a stash was
  # actually created, so an older unrelated stash is never applied.
  set -l before (git rev-parse -q --verify refs/stash)
  git stash push -q --keep-index --include-untracked; or return
  set -l after (git rev-parse -q --verify refs/stash)

  # Run test command against index changes only.
  command $argv
  set -l cmdstatus $status

  if test "$before" != "$after"
    # Return working dir and index to original state.
    # Note: reset + restore is required to prevent merge conflicts
    # when popping the stash.
    git reset -q
    git restore :/
    git stash pop -q --index; or return $status
  end

  return $cmdstatus
end
