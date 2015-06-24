DOTREPOS = File::expand_path("#{ENV['HOME']}/.repos")
DOTSSH = File::expand_path("#{ENV['HOME']}/.ssh")

### Setup ghq
execute 'Repository を管理するディレクトリを作成する' do
  command "mkdir -p #{DOTREPOS}"
  not_if Dir.exist?("#{DOTREPOS}")
end
execute 'Git に ghq セクションの設定を行う' do
  command "git config --global --replace-all ghq.root #{DOTREPOS}"
end

### Get SSH Files
DOTSSHFILES = "#{DOTREPOS}/$(ghq list | grep '#{node['ghq']['dotssh']['repo']}')"
execute '既存の SSH Files を削除する' do
  command "rm -rf #{DOTSSH}"
  only_if "test -d #{DOTSSH}"
end
execute 'SSH Files リポジトリを Clone する' do
  command "ghq get #{node['ghq']['dotssh']['url']}"
  not_if "ghq list | grep -q '#{node['ghq']['dotssh']['repo']}'"
end
execute 'Clone した SSH Files のパーミッションを変更する' do
  command "chmod 755 #{DOTSSHFILES} && chmod 655 #{DOTSSHFILES}/* && chmod 600 #{DOTSSHFILES}/id_*"
  only_if "test -d #{DOTSSHFILES}"
end
execute 'Clone した SSH Files にシンボリックリンクを作成する' do
  command "ln -fsn #{DOTSSHFILES} #{DOTSSH}"
  only_if "test -d #{DOTSSHFILES}"
end

### Clone Repositories
enable_get = node['ghq']['enable_get'] ? node['ghq']['enable_get'] : false
if enable_get
  node['ghq']['get_repos'].each do |repo|
    execute 'ghq get で各種リポジトリをローカルに Clone する' do
      command "ghq get #{repo}"
      not_if "ghq list | grep -q '#{repo}'"
      only_if "test -L #{DOTSSH}"
    end
  end
else
  Logger.info("['ghq']['enable_get'] の設定により、 ghq get を実施しません")
end

### Setup RictyDiminished
RICTYREPO = "#{DOTREPOS}/$(ghq list | grep 'RictyDiminished')"
execute 'Ricty Diminished をインストールする' do
  command "find #{RICTYREPO} -name 'Ricty*.ttf' |xargs -J % cp -f % ~/Library/Fonts/ && fc-cache -vf"
  only_if "test -d #{RICTYREPO}"
end


