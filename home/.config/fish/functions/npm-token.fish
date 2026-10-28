function npm-token -d "Export NPM_TOKEN for Cloudflare's private npm registry (@cloudflare, @cf-internal)"
  # Cached Access token first (no browser); interactive login only when it is missing or expired.
  # pnpm/npm config reference the literal ${NPM_TOKEN}, so the token itself never lands on disk.
  set -l registry_app https://registry.cloudflare-ui.com
  set -l token (cloudflared access token --app=$registry_app 2>/dev/null)
  if test -z "$token"
    echo "npm-token: logging in to $registry_app..." >&2
    set token (cloudflared access login --no-verbose $registry_app)
    or begin
      echo "npm-token: Cloudflare Access login failed" >&2
      return 1
    end
  end
  if test -z "$token"
    echo "npm-token: cloudflared returned an empty token" >&2
    return 1
  end
  set -gx NPM_TOKEN $token
  echo "npm-token: NPM_TOKEN set" >&2
end
