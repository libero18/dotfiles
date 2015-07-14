### Install Vagrant Plugin
to_enable = node['vagrant']['to_enable'] ? node['vagrant']['to_enable'] : false
if to_enable
  node['vagrant']['pulgins'].each do |plugin|
    execute "install vagrant plugins" do
      command "vagrant plugin install #{plugin}"
      only_if "test $(which vagrant)"
    end
  end
else
  Logger.info('Execution skipped install vagrant plugins because of not true to_enable')
end

### Install Vagrant Box
to_enable = node['vagrant']['to_enable'] ? node['vagrant']['to_enable'] : false
if to_enable
  node['vagrant']['boxes'].each do |box|
    execute "install vagrant boxes" do
      command "vagrant box add --force #{box}"
      only_if "test $(which vagrant)"
    end
  end
else
  Logger.info('Execution skipped install vagrant boxes because of not true to_enable')
end
