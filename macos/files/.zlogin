## Executes commands at login post-zshrc.

## ログイン時のみ最初にバックエンドで実行する
{
  ## oh-my-zsh theme
  if [ ! -L ${HOME}/repos/github.com/robbyrussell/oh-my-zsh/custom/libero18.zsh-theme ]; then 
    ln -s ${HOME}/repos/github.com/libero18/dotfiles/macos/files/.etc/libero18.zsh-theme ${HOME}/repos/github.com/robbyrussell/oh-my-zsh/custom/
  fi
  ## Heroku Toolbelt
  if [ -d /usr/local/heroku/bin ]; then
    export PATH="/usr/local/heroku/bin:$PATH"
  fi
} &!

