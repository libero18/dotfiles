## Executes commands at login post-zshrc.

## ログイン時のみ最初にバックエンドで実行する
{
  if [ -f /Users/nakajima/repos/github.com/libero18/dotfiles/macos/files/.bin/Symlinks.sh ]; then
    /Users/nakajima/repos/github.com/libero18/dotfiles/macos/files/.bin/Symlinks.sh
  fi
  ## Heroku Toolbelt
  if [ -d /usr/local/heroku/bin ]; then
    export PATH="/usr/local/heroku/bin:$PATH"
  fi
} &!

