# Defines environment variables.

## 起動速度調査などプロファイル実行したいときだけ有効にする
# zmodload zsh/zprof && zprof

## User specific environment and startup programs
## Ensure that a non-login, non-interactive shell has a defined environment.
if [[ "$SHLVL" -eq 1 && ! -o LOGIN && -s "${HOME}/.zprofile" ]]; then
  source "${HOME}/.zprofile"
fi

## User specific aliases and functions
alias rm='rm -i'
alias cp='cp -i'
alias mv='mv -i'
alias vi='vim'
alias Coda2="open -a /Applications/Coda\ 2.app"
alias atom="open -a /Applications/Atom.app"
alias rake='bundle exec rake'
alias rhttpd='ruby -run -e httpd . -p 5000'
alias st='/Applications/Sublime\ Text.app/Contents/SharedSupport/bin/subl'

## dotfile用のスクリプトpathを設定
if [ -d $HOME/.bin ]; then
  export PATH="$HOME/.bin:$PATH"
fi

## anyenvの環境pathを指定(rbenv/pyenv/plenv/phpenv/ndenv)
if [ -d $HOME/.anyenv/bin ]; then
  export PATH="$HOME/.anyenv/bin:./.bundle/bin:$PATH"
fi

## Ansible
if command -v ansible-playbook &>/dev/null; then
  function ansible-playbook_wrapper() {
    if [ $(git log -n 1 >/dev/null 2>&1 ; echo $?) -eq 0 ]; then
      \ansible-playbook $@ -e "playbook_version=$(git log -n 1 | head -n 1 | awk -F " " '{print $2}')"
    else
      \ansible-playbook $@
    fi
  }
  alias ansible-playbook=ansible-playbook_wrapper
fi

## Homebrew
if command -v brew &>/dev/null; then
  export PATH="/usr/local/bin:/usr/local/sbin:$PATH"
fi
if command -v brew-cask &>/dev/null; then
  export HOMEBREW_CASK_OPTS="--appdir=/Applications"
fi

## Go
if [ -z "${GOPATH:-}" ]; then
  export GOPATH="$HOME/.go"
  export PATH="$GOPATH/bin:$PATH"
fi

## ghq
function r2t() {
  local fn
  while read fn
  do
    echo ${fn/$HOME/"~"}
  done
}

alias ghcd='LINE=$(ghq list -p | r2t | peco); cd ${LINE/"~"/$HOME}'
alias ghop='LINE=$(ghq list -p | r2t | peco); gh-open ${LINE/"~"/$HOME}'

## Ctrl + R でコマンド履歴検索
function peco-select-history() {
  local tac
  if which tac > /dev/null; then
    tac="tac"
  else
    tac="tail -r"
  fi
  BUFFER=$(\history -n 1 | \
    eval $tac | \
    peco --query "$LBUFFER")
  CURSOR=$#BUFFER
  zle clear-screen
}
zle -N peco-select-history
bindkey '^r' peco-select-history

## Rake
alias pake='LINE=$(rake -T |awk '\''{print $2}'\'' | peco); rake ${LINE}'

## vagrant
if command -v vagrant &>/dev/null; then
  export SSL_CERT_FILE=/usr/local/etc/openssl/cert.pem
fi


