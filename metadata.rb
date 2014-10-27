name             "etckeeper"
maintainer       "Alexander Saharchuk and Steffen Gebert, Bastian Bringenberg, Peter Niederlag / TYPO3 Association"
maintainer_email "alexander@saharchuk.com"
license          "Apache 2.0"
description      "Installs/Configures etckeeper"
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          "1.0.4"
recipe           "etckeeper", "Install etckeeper and start local using etckeeper with etckeeper::config"
recipe           "etckeeper::config", "Config etckeeper. Set VCS for local using. And add hooks if remote repo using"
recipe           "etckeeper::commit", "Use with chef-run"

%w{redhat centos scientific fedora debian ubuntu arch freebsd amazon gentoo}.each do |os|
  supports os
end

depends "chef_handler"
depends "git"

attribute "etckeeper/dir",
  :display_name => "Path for etckeeper dir",
  :description => "Default path from package",
  :default => "/etc/etckeeper"
attribute "etckeeper/config",
  :display_name => "Path for etckeeper config",
  :description => "Default path from package",
  :default => "/etc/etckeeper/etckeeper.conf"
attribute "etckeeper/vcs",
  :display_name => "VCS in etckeeper",
  :description => "Type of VCS which using at etckeeper",
  :default => "git"
attribute "etckeeper/use_remote",
  :display_name => "etckeeper flag for remote repo using",
  :description => "Using with git remote repo",
  :default => "false"
attribute "etckeeper/daily_auto_commits",
  :display_name => "etckeeper daily auto commits",
  :description => "Do etckeeper commits every day",
  :default => true
attribute "etckeeper/special_file_warning",
  :display_name => "suppress etckeeper special file warning",
  :description => "suppress etckeeper special file warning",
  :default => true
attribute "etckeeper/commit_before_install",
  :display_name => "etckeeper commit before install",
  :description => "do daily etckeeper commit",
  :default => true
attribute "etckeeper/git_email",
  :display_name => "etckeeper git email address",
  :description => "email address to use for git commits",
  :default => "root@<fqdn>"
