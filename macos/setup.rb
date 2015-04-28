#!/usr/bin/env ruby

### Environment Variable
USER = 'libero18'
INSTALLER = "https://github.com/#{USER}/dotfiles/archive/master.zip"
SSHFILES = "https://#{USER}@bitbucket.org/#{USER}/.ssh.git"
WORKINGDIR = '/tmp/dotfiles'
TMPFILE = '/tmp/dotfiles.zip'


### input bitbucket password
require "io/console"
require "readline"
PASSWORD = STDIN.noecho { Readline.readline("#{USER}@bitbucket.org Password: ").tap { puts } }


### Download installer
system("curl -LSfs -o #{TMPFILE} #{INSTALLER}")
system("sudo unzip -oq #{TMPFILE} -d #{WORKINGDIR}")
APPLESCRIPTDIR = File::expand_path("#{WORKINGDIR}/macos/script/AppleScript/")
SERVERKITDIR = File::expand_path("#{WORKINGDIR}/macos/script/Serverkit/")


### cd working path
require 'shell'
shell = Shell.new
shell.pushd "#{WORKINGDIR}/dotfiles-master"


### Xcode Command Line Tools
unless system('sudo xcode-select -p > /dev/null 2>&1')
  SCRIPTDIR = "#{APPLESCRIPTDIR}/xcode-command-line-tools"
  DB = '/Library/Application\ Support/com.apple.TCC/TCC.db'
  SUPPORTED_TERMINALS = %w[
    com.apple.Terminal
    com.googlecode.iterm2
  ]

  SUPPORTED_TERMINALS.each do |terminal|
    system('$(sudo sqlite3 "#{DB} INSERT OR REPLACE INTO access VALUES(\'kTCCServiceAccessibility\',\'#{terminal}\',0,1,1,NULL);")')
  end

  system('sudo xcode-select --install')
  system("sudo osascript #{SCRIPTDIR}/start_install.scpt")
  sleep 3 until system('sudo xcode-select -p > /dev/null 2>&1')
  system("sudo osascript #{SCRIPTDIR}/click_done.scpt")
end


### Homebrew
HOMEBREWINSTALLER = 'https://raw.githubusercontent.com/Homebrew/install/master/install'
system("sudo curl -fsSL #{HOMEBREWINSTALLER} | ruby") unless system('sudo which brew > /dev/null')


# Install serverkit and its dependencies
system('sudo gem install bundler') unless system('sudo which bundle > /dev/null')
system('sudo bundle install --path vendor/bundle --binstubs .bundle/bin > /dev/null')
system('sudo bundle clean > /dev/null')


# Run installer
case ARGV[0]
when 'client'
  system("sudo bundle exec serverkit apply setup.yml.erb --variables=client.yml")
when 'server'
  system("sudo bundle exec serverkit apply setup.yml.erb --variables=server.yml")
end


### cd original path
shell.popd


# Cleanup
system("sudo rm -rf #{TMPFILE} #{WORKINGDIR}")

