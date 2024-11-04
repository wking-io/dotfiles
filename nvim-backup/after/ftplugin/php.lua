local phpcs = require("lint").linters.phpcs
phpcs.args = {
  "-q",
  -- <- Add a new parameter here
  "--standard=PSR2",
  "--report=json",
  "-",
}

print(vim.inspect(phpcs.args))
