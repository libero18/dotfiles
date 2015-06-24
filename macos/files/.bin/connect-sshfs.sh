#!/bin/sh

CURRENT_MNT_DIR=/Users/nakajima/.mntsshfs
REMOTE_DIR=${REMOTE_DIR:-/home/nakajima}

mount_sshfs() {
  if [ ! -d ${CURRENT_MNT_DIR}/$1 ]; then
    mkdir ${CURRENT_MNT_DIR}/$1
  fi
  sshfs $1:${REMOTE_DIR} ${CURRENT_MNT_DIR}/$1
}

umount_sshfs() {
  umount ${CURRENT_MNT_DIR}/$1
}

case "$1" in
mount)
  mount_sshfs $2
  ;;
umount)
  umount_sshfs $2
  ;;
*)
  echo "\nUsage:"
  echo "$0 mount 接続先"
  echo "$0 umount 接続先"
  exit 1
  ;;
esac

exit 0

