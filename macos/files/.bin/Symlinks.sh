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
    ln -Fis "$PWD/$dotfile" $HOME
fi
done

cd -
exit 0
