### Vagrant Plugin
to_enable = node['vagrant']['to_enable'] ? node['vagrant']['to_enable'] : false
if to_enable
  node['vagrant']['pulgins'].each do |plugin|
    execute "install vagrant plugins" do
      command "vagrant plugin install #{plugin}"
      only_if "test $(which vagrant)"
    end
  end
  enable_update = node['vagrant']['enable_update'] ? node['vagrant']['enable_update'] : false
  if enable_update
    execute "update vagrant plugins" do
      command "vagrant plugin update"
      only_if "test $(which vagrant)"
    end
  end
else
  Logger.info('Execution skipped vagrant plugins because of not true to_enable')
end

### Vagrant Box
to_enable = node['vagrant']['to_enable'] ? node['vagrant']['to_enable'] : false
if to_enable
  node['vagrant']['boxes'].each do |box|
    execute "install vagrant boxes" do
      command "vagrant box add --force #{box}"
      only_if "test $(which vagrant)"
    end
  end
else
  Logger.info('Execution skipped vagrant boxes because of not true to_enable')
end
