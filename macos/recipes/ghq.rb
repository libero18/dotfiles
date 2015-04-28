### Setup
DOTREPOS = File::expand_path("#{ENV['HOME']}/.repos")
execute "mkdir -p .repos" do
  command "mkdir -p #{DOTREPOS}"
  not_if Dir.exist?("#{DOTREPOS}")
end
execute "git config --global ghq.root" do
  command "git config --global ghq.root #{DOTREPOS}"
end

### Get SSH Files
DOTSSH = File::expand_path("#{ENV['HOME']}/.ssh")
DOTSSHFILES = "#{DOTREPOS}/$(ghq list | grep '#{node['ghq']['dotssh']['repo']}')"
execute 'ghq get .ssh' do
  command "ghq get #{node['ghq']['dotssh']['url']}"
  not_if "ghq list | grep -q '#{node['ghq']['dotssh']['repo']}'"
end
execute 'chmod .ssh' do
  command "chmod 755 #{DOTSSHFILES} && chmod 655 #{DOTSSHFILES}/* && chmod 600 #{DOTSSHFILES}/id_*"
  only_if "test -d #{DOTSSHFILES}"
end
execute 'rm .ssh' do
  command "rm -rf #{DOTSSH}"
  only_if "test -d #{DOTSSH}"
end
execute 'symlink .ssh' do
  command "ln -fsn #{DOTSSHFILES} #{DOTSSH}"
  only_if "test -d #{DOTSSHFILES}"
end

### Clone Repositories
enable_get = node["ghq"]["enable_get"] ? node["ghq"]["enable_get"] : false
if enable_get
  node["ghq"]["get_repos"].each do |repo|
    execute "ghq get repositories" do
      command "ghq get #{repo}"
      not_if "ghq list | grep -q '#{repo}'"
      only_if "test -L #{DOTSSH}"
    end
  end
else
  Logger.info("Execution skipped 'ghq gwt repositories' because of not true enable_get")
end
