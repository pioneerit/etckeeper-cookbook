name             "etckeeper"
maintainer       "Steffen Gebert, Bastian Bringenberg, Peter Niederlag / TYPO3 Association (based on work by Alexander Saharchuk)"
maintainer_email "alexander@saharchuk.com"
license          "Apache 2.0"
description      "Installs/Configures etckeeper"
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          "1.0.0"

depends "chef_handler"
depends "cron"
depends "git"
