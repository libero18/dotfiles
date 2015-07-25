### anyenv
to_setup = node['anyenv']['to_setup'] ? node['anyenv']['to_setup'] : false
if to_setup

  ### symlinks


  ### rbenv
  to_enable = node['anyenv']['rbenv']['to_enable'] ? node['anyenv']['rbenv']['to_enable'] : false
  if to_enable
    ### install rbenv

    ### symlinks
=begin

    if [ -d ${HOME}/.repos/github.com/riywo/anyenv -a ! -L $HOME/.anyenv ]; then
      ln -fs $HOME/.repos/github.com/riywo/anyenv $HOME/.anyenv >/dev/null 2>&1
    fi

    ## anyenv-update
    if [ -L $HOME/.anyenv -a ! -d $HOME/.anyenv/plugins ]; then
      mkdir -p $HOME/.anyenv/plugins >/dev/null 2>&1
    fi
    if [ -L $HOME/.anyenv -a ! -L $HOME/.anyenv/plugins/anyenv-update ]; then
      ln -fs $HOME/.repos/github.com/znz/anyenv-update $HOME/.anyenv/plugins/anyenv-update >/dev/null 2>&1
    fi

    ## rbenv-plug
    if [ -L $HOME/.anyenv -a ! -d ${HOME}/.anyenv/envs/rbenv ]; then
      ${HOME}/.anyenv/bin/anyenv install rbenv >/dev/null 2>&1
    fi
    if [ -L $HOME/.anyenv -a ! -L $HOME/.anyenv/envs/rbenv/plugins/rbenv-plug ]; then
      ln -fs $HOME/.repos/github.com/znz/rbenv-plug $HOME/.anyenv/envs/rbenv/plugins/rbenv-plug >/dev/null 2>&1
    fi

    ## rbenv-default-gems
    if [ -d ${HOME}/.anyenv/envs/rbenv -a ! -L ${HOME}/.anyenv/envs/rbenv/default-gems ]; then
      ln -fs $HOME/.etc/default-gems ${HOME}/.anyenv/envs/rbenv/default-gems >/dev/null 2>&1
    fi

=end





    ### install rbenv plugins
    node['anyenv']['rbenv']['pulgins'].each do |plugin|
      execute "install rbenv plugins" do
        command "$HOME/.anyenv/envs/rbenv/bin/rbenv plug #{plugin}"
        only_if "test $(which $HOME/.anyenv/envs/rbenv/bin/rbenv)"
      end
    end

    ### rbenv rehash
    execute "rbenv rehash" do
      command "$HOME/.anyenv/envs/rbenv/bin/rbenv rehash"
      only_if "test $(which $HOME/.anyenv/envs/rbenv/bin/rbenv)"
    end

  end

  ### anyenv update
  enable_update = node['anyenv']['enable_update'] ? node['anyenv']['enable_update'] : false
  if enable_update
    execute "update anyenv" do
      command "anyenv update"
      only_if "test $(which anyenv)"
    end
  end

else
  Logger.info('Execution skipped anyenv setup because of not true to_setup')
end
