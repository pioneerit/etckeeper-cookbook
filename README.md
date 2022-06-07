Description
===========
Install and configure etckeeper.
Thanks to maintainers from [TYPO3 Association](https://github.com/TYPO3-cookbooks):
* *Steffen Gebert*
* *Bastian Bringenberg*
* *Peter Niederlag*
Thanks to [Bernhard Weisshuhn](https://github.com/bkw) for begininig.

Requirements
============
* `recipe['chef_handler']`
* `recipe['git']`

Attributes
==========
```ruby
# Setting up the remote configuration
default['etckeeper']['git_host'] = "github.com"
default['etckeeper']['git_port'] = "22"
default['etckeeper']['git_repo'] = "etckeeper"
default['etckeeper']['git_branch'] = node['fqdn']
default['etckeeper']['git_email'] = "root@#{node['fqdn']}"
# Setting up the configuration file
default['etckeeper']['config_file']['VCS'] = git
default['etckeeper']['config_file']['AVOID_DAILY_AUTOCOMMITS'] = 1
default['etckeeper']['config_file']['AVOID_SPECIAL_FILE_WARNING'] = 1
default['etckeeper']['config_file']['AVOID_COMMIT_BEFORE_INSTALL'] = 1
# Setting up the Handler (if 'etckeeper::commit' is included)
# This attributes set the path for the commit handler to be placed
default['etckeeper']['handler_path'] = "#{File.expand_path(File.join(Chef::Config[:file_cache_path], '..'))}/handlers"
```

Usage
=====
* Add to run_list `recipe['etckeeper']` for local using etckeeper
* Set either ['git_host']`, ['git_repo'] or ['git_port'] for daily auto push to remote:
 * Make ssh key and copy to `./files/default/etckeeper_key` or create a wrapper cookbook with the ssh key you want to deploy then set following attribute: `node['etckeeper']['ssh']['key']['cookbook']`
 * Set your `git_host` and `git_port` if your need
 * Set at atribute for git repo. For example github repo `default['etckeeper']['git_repo'] = "myuser/myrepo.git"`

Etckeeper::Commit
=================

This recipe will do two things

* In the beginning of the chef-run, check if `/etc` is unclean. If yes, fail the chef-run.
* After the chef-run, a report handler will commit the changes made to `/etc` during this chef-run.


Changelog
=========

1.0.5 (unreleased)
-----
Updates from [Jeremy MAURO](https://github.com/jmauro):
* #14 make tests compliant with the latest version of Chefspec and chef
* #15 remove the 'old' fix of the cronjob
* #16 add the cookbook attribute on the resource that deploys the ssh key, so
now, the user is able to override this value with a wrapper cookbook

1.0.4
-----
Updates from [Bernhard Weisshuhn](https://github.com/bkw):
* switched to berkshelf v3
* added chefspec tests
* added rubocop checks
* added foodcritic checks
* added travis-ci
* added serverspec tests
* clean up leftovers from old cookbook versions
* remove bzr directory (for vcs git)
* initialize etckeeper upon installation
* set email in git config via attribute

1.0.3
-----

* new attributes, by Yuya.Nishida (@nishidayuya)
    * daily_auto_commits
    * special_file_warning
    * commit_before_install
* gentoo support, by Florian Eitel (@nougad)
* fixes to cron job, by Florian Eitel (@nougad)
* use etckeeper internal cpmmit push functionality, by Florian Eitel (@nougad)
* tighter permissions for /root/.ssh, by Florian Eitel (@nougad)
* removed old chef handler, by @arr-dev

1.0.2
-----

* Use StrictHostKeyChecking for disable authenticity host checking

1.0.1
-----

* Merge with TYPO3
* Remove unnecessary attributes
* Remove manual adding cron task - only change cron.daily screept if use remote
* Change from post-install push - to commit push
* Remove init from config. Now remote checking on etcekeeper commit hook
* Few renames for simple code view
