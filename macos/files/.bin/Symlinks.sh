#!/bin/sh

function __readlinkf {
  TARGET_FILE=$1

  while [ "$TARGET_FILE" != "" ]; do
      cd `dirname $TARGET_FILE`
      FILENAME=`basename $TARGET_FILE`
      TARGET_FILE=`readlink $FILENAME`
  done

  echo `pwd -P`/$FILENAME
}

scriptdir=$(cd $(dirname $(__readlinkf ${BASH_SOURCE:-$0})); pwd)

cd `find ${scriptdir}/../../ -type d -name "files"`

for dotfile in .?*
do
  if [ $dotfile != '..' ] && [ $dotfile != '.git' ]
  then
    ln -Fs "$PWD/$dotfile" $HOME
fi
done

## .ssh
if [ -d ${HOME}/.repos/bitbucket.org/libero18/.ssh ]; then
  ln -Fs $HOME/.repos/bitbucket.org/libero18/.ssh $HOME/.ssh
fi

## anyenv
if [ -d ${HOME}/.repos/github.com/riywo/anyenv ]; then
  ln -Fs $HOME/.repos/github.com/riywo/anyenv $HOME/.anyenv
fi

## oh-my-zsh theme
if [ ! -L ${HOME}/.repos/github.com/robbyrussell/oh-my-zsh/custom/libero18.zsh-theme ]; then
  ln -s ${HOME}/.repos/github.com/libero18/dotfiles/macos/files/.etc/libero18.zsh-theme ${HOME}/repos/github.com/robbyrussell/oh-my-zsh/custom/
fi

cd -
exit 0
