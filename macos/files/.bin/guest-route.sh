#!/bin/sh

start() {
  sudo route add 192.168.112.0/24 192.168.112.254
}

stop() {
  sudo route delete 192.168.112.0/24
}

case "$1" in
  start)
    start
  ;;
  stop)
    stop
  ;;
  restart)
    stop
    start
  ;;
  *)
    echo "Usage: vpn-route {start|stop|restart}"
    exit 1
esac
