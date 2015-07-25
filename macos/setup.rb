#!/usr/bin/env ruby

### Environment Variable
USER = 'libero18'
REPO = 'dotfiles'
URL = "https://github.com/#{USER}/#{REPO}/archive/master.zip"
TMPDIR = '/tmp'
TMPFILE = "#{TMPDIR}/master.zip"
WORKINGDIR = "#{TMPDIR}/#{REPO}"
SCPTDIR = File::expand_path("#{WORKINGDIR}/#{REPO}-master/macos/scpt")
RECIPEDIR = File::expand_path("#{WORKINGDIR}/#{REPO}-master/macos/recipes")
NODEDIR = File::expand_path("#{WORKINGDIR}/#{REPO}-master/macos/nodes")


### Required Packages
require 'io/console'
require 'find'
require 'shell'


### Download installer
system("test -d #{TMPDIR}/#{REPO} && sudo rm -rf #{TMPDIR}/#{REPO}")
system("curl -LSfs -o #{TMPFILE} #{URL}")
system("unzip -oq #{TMPFILE} -d #{TMPDIR}/#{REPO}")
system("rm -rf #{TMPFILE}")


### select install type
nodes = Array.new
node = ''
Find.find("#{NODEDIR}") do |path|
  next unless FileTest.file?(path)
  nodes.push(File.basename(path, '.yml'))
end
node = ENV["NODE"] if ENV["NODE"]
until nodes.include?(node.to_s) do
  io = IO.console
  print "Select Node Type ? ( #{nodes.join(' | ')} ): "
  node = io.noecho(&:gets).chop
  print "\n"
end
NODE = node


### sudo
system("sudo sh -c \"echo '#includedir /etc/sudoers.d' >> /etc/sudoers\"") unless system("sudo cat /etc/sudoers | grep '^#includedir\s*/etc/sudoers.d$' > /dev/null 2>&1")
unless system('test -d /etc/sudoers.d > /dev/null 2>&1')
  system('sudo mkdir -p /etc/sudoers.d')
  system('sudo chown root:wheel /etc/sudoers.d')
  system('sudo chmod 755 /etc/sudoers.d')
end
if system('test -d /etc/sudoers.d > /dev/null 2>&1')
  system("sudo sh -c \"echo '%wheel ALL=(ALL) NOPASSWD: ALL' > /etc/sudoers.d/wheel\"")
  system('sudo chown root:wheel /etc/sudoers.d/wheel')
  system('sudo chmod 440 /etc/sudoers.d/wheel')
end
system('sudo dscl . -append /Groups/wheel GroupMembership $(whoami)') unless system('dscl . -read /Groups/wheel | grep ^GroupMembership | grep $(whoami) > /dev/null 2>&1')


### Xcode Command Line Tools (Run AppleScript)
unless system('xcode-select -p > /dev/null 2>&1')
  system("sudo osascript #{SCPTDIR}/xcode-select-install.scpt")
  sleep 5 until system('xcode-select -p > /dev/null 2>&1')
  system("sudo osascript #{SCPTDIR}/xcode-select-install-done.scpt")
end


### Start
sh = Shell.new
sh.pushd "#{WORKINGDIR}/#{REPO}-master/macos"
sh.system("git config --global credential.helper osxkeychain")


# Install Itamae and its dependencies
sh.system('sudo gem install bundler') unless system('sudo which bundle > /dev/null')
sh.system('sudo bundle install --path vendor/bundle --binstubs .bundle/bin > /dev/null')
sh.system('sudo bundle clean > /dev/null')


### Run Itamae
sh.system('rm -f /tmp/itamae.log') unless File.exist?('/tmp/itamae.log')
def _cmd_itamae(recipe='')
  unless recipe.to_s.empty?
    "bundle exec itamae local #{RECIPEDIR}/#{recipe}.rb -y #{NODEDIR}/#{NODE}.yml -l debug --no-color >> /tmp/itamae.log"
  end
end


### Homebrew
sh.system(_cmd_itamae('brew'))

### Clone Repository && Setup
sh.system(_cmd_itamae('repo'))

### Vagrant
sh.system(_cmd_itamae('vagrant'))

### anyenv
sh.system(_cmd_itamae('anyenv'))

### End
sh.system('$HOME/.repos/github.com/libero18/dotfiles/macos/files/.bin/Symlinks.sh')
sh.popd


### Cleanup
system("sudo rm -rf #{WORKINGDIR}") if system("test -d #{WORKINGDIR} > /dev/null 2>&1")
