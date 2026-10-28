function cbsudo
  set -x X_CRUNCHY_SUDO true
  set -x X_CRUNCHY_SUDO_ACCOUNT $argv[1]
  cb $argv[2..-1]
end

function _complete_cbsudo
  set arglist (commandline -cp | string split --max 2 --no-empty " ")
  set user $arglist[2]
  set cmd_wo_user $arglist[1] $arglist[3]
  if not set -q arglist[3]
    return 0
  end
  set -x X_CRUNCHY_SUDO true
  set -x X_CRUNCHY_SUDO_ACCOUNT $user
  cb --_completion "$cmd_wo_user"
end

complete --command cbsudo --arguments '(_complete_cbsudo)' --no-files