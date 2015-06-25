#!/bin/sh

function __readlinkf {
  TARGET_FILE=$1

  while [ "$TARGET_FILE" != "" ]; do
      cd $(dirname $TARGET_FILE)
      FILENAME=$(basename $TARGET_FILE)
      TARGET_FILE=$(readlink $FILENAME)
  done

  echo $(pwd -P)/$FILENAME
}

scriptdir=$(cd $(dirname $(__readlinkf ${BASH_SOURCE:-$0})); pwd)

cd $(find ${scriptdir}/../../ -type d -name "files") >/dev/null 2>&1

for dotfile in .?*
do
  if [ $dotfile != '..' ] && [ $dotfile != '.git' ]
  then
    ln -fs "$PWD/$dotfile" $HOME >/dev/null 2>&1
fi
done

## .ssh
if [ -d ${HOME}/.repos/bitbucket.org/libero18/.ssh -a ! -L $HOME/.ssh ]; then
  ln -fs $HOME/.repos/bitbucket.org/libero18/.ssh $HOME/.ssh >/dev/null 2>&1
fi

## oh-my-zsh theme
if [ ! -L ${HOME}/.repos/github.com/robbyrussell/oh-my-zsh/custom/libero18.zsh-theme ]; then
  ln -fs ${HOME}/.repos/github.com/libero18/dotfiles/macos/files/.etc/libero18.zsh-theme ${HOME}/repos/github.com/robbyrussell/oh-my-zsh/custom/ >/dev/null 2>&1
fi

## anyenv
if [ -d ${HOME}/.repos/github.com/riywo/anyenv -a ! -L $HOME/.anyenv ]; then
  ln -fs $HOME/.repos/github.com/riywo/anyenv $HOME/.anyenv >/dev/null 2>&1
fi

## anyenv-update
if [ -L $HOME/.anyenv ]; then
  if [ ! -d $HOME/.anyenv/plugins ]; then
    mkdir -p $HOME/.anyenv/plugins
  fi
  if [ ! -L $HOME/.anyenv/plugins/anyenv-update ]; then
    ln -fs $HOME/.repos/github.com/znz/anyenv-update $HOME/.anyenv/plugins/anyenv-update >/dev/null 2>&1
  fi
fi

## rbenv-plug
if [ -L $HOME/.anyenv ]; then
  if [ ! -d ${HOME}/.anyenv/envs/rbenv ]; then
    ${HOME}/.anyenv/bin/anyenv install rbenv
    source $HOME/.zshrc
  fi
  if [ ! -L $HOME/.anyenv/envs/rbenv/plugins/rbenv-plug ]; then
    ln -fs $HOME/.repos/github.com/znz/rbenv-plug $HOME/.anyenv/envs/rbenv/plugins/rbenv-plug >/dev/null 2>&1
  fi
fi

cd - >/dev/null 2>&1
exit 0
