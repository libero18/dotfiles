#!/bin/sh

start() {
  sudo route add 192.168.41.0/24 192.168.12.1
  sudo route add 192.168.11.0/24 192.168.12.1
  sudo route add 192.168.12.0/24 192.168.12.1
}

stop() {
  sudo route delete 192.168.41.0/24
  sudo route delete 192.168.11.0/24
  sudo route delete 192.168.12.0/24
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
