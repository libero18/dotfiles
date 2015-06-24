# Executes commands at the start of an interactive session.

## Source global definitions
if [ -f /etc/zshrc ]; then
    . /etc/zshrc
fi

## Source User definitions
if [ -f ${HOME}/.zshenv ]; then
    . ${HOME}/.zshenv
fi

# Customize to your needs...

## プロファイル(起動速度調査などに利用する)
if (which zprof > /dev/null) ;then
  zprof | less
fi

## direnv
if command -v direnv &>/dev/null; then
  eval "$(direnv hook zsh)"
fi

## anyenv
if [ -d $HOME/.anyenv/bin ]; then
  eval "$(anyenv init - zsh)"
fi

# Source oh-my-zsh
if [ -f ${HOME}/.repos/github.com/robbyrussell/oh-my-zsh/oh-my-zsh.sh ]; then
    . ${HOME}/.zshenv-oh-my-zsh
fi

## gem travis
[ -f ~/.travis/travis.sh ] && source ~/.travis/travis.sh

## boot2docker
if command -v boot2docker &>/dev/null; then
  Socket="tcp://$(boot2docker ip 2>/dev/null):2376"
  Routing="sudo route add -net 172.17.0.0/16 $(boot2docker ip 2>/dev/null)"
  if [ "$(boot2docker status 2> /dev/null)" = 'running' ]; then
    export DOCKER_HOST=${Socket}
    export DOCKER_CERT_PATH=${HOME}/.boot2docker/certs/boot2docker-vm
    export DOCKER_TLS_VERIFY=1
  fi

  compdef _boot2dockercmd boot2docker_wrapper
  function _boot2dockercmd {
    local -a cmds
    if (( CURRENT == 2 ));then
      cmds=('init' 'up' 'start' 'boot' 'ssh' 'save' 'suspend' 'down' 'stop' 'halt' 'restart' 'poweroff' 'reset' 'delete' 'destroy' 'config' 'cfg' 'info' 'ip' 'shellinit' 'status' 'download' 'upgrade' 'version')
      _describe -t commands "subcommand" cmds
    else
      _files
    fi
    return 1;
  }

  function boot2docker_wrapper() {
    if [ $1 = 'up' -o $1 = 'start' -o $1 = 'boot' ]; then
      shift
      \boot2docker up $@ && export DOCKER_HOST=${Socket} && sh -c ${Routing}
    elif [ $1 = 'restart' ]; then
      shift
      \boot2docker restart $@ && export DOCKER_HOST=${Socket} && sh -c ${Routing}
    else
      \boot2docker $@
    fi
  }

  alias boot2docker=boot2docker_wrapper
fi

## test-kitchen
if command -v kitchen &>/dev/null; then
  function kitchen_wrapper() {
    if [ "$#" -eq 1 ]; then
      case "$1" in
        converge)
          shift
          \kitchen converge $(echo -e "all "$(kitchen list -b) | tr ' ' '\n' | sort | peco)
          ;;
        create)
          \kitchen create $(echo -e "all "$(kitchen list -b) | tr ' ' '\n' | sort | peco)
          ;;
        destroy)
          \kitchen destroy $(echo -e "all "$(kitchen list -b) | tr ' ' '\n' | sort | peco)
          ;;
        login)
          \kitchen login $($(kitchen list -b) | sort | peco)
          ;;
        setup)
          \kitchen setup $(echo -e "all "$(kitchen list -b) | tr ' ' '\n' | sort | peco)
          ;;
        test)
          \kitchen test $(echo -e "all "$(kitchen list -b) | tr ' ' '\n' | sort | peco)
          ;;
        verify)
          \kitchen verify $(echo -e "all "$(kitchen list -b) | tr ' ' '\n' | sort | peco)
          ;;
        *)
          \kitchen $@
      esac
    else
      \kitchen $@
    fi
  }

  alias kitchen=kitchen_wrapper
fi

## PATH の重複削除
typeset -U path PATH

