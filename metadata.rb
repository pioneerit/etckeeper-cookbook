name             "etckeeper"
maintainer       "Oleksandr Sakharchuk and Steffen Gebert, Bastian Bringenberg, Peter Niederlag / TYPO3 Association, Jeremy Mauro"
maintainer_email "alexander@saharchuk.com"
license          "MIT"
description      "Installs/Configures etckeeper"
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          "1.0.5"
recipe           "etckeeper", "Install etckeeper and start local using etckeeper with etckeeper::config"
recipe           "etckeeper::config", "Config etckeeper. Set VCS for local using. And add hooks if remote repo using"
recipe           "etckeeper::commit", "Use with chef-run"
issues_url       "https://github.com/pioneerit/etckeeper-cookbook/issues"
source_url       "https://github.com/pioneerit/etckeeper-cookbook"

%w{redhat centos scientific fedora debian ubuntu arch freebsd amazon gentoo}.each do |os|
  supports os
end

depends "git"
depends "yum-epel"
