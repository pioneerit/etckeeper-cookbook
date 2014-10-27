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
default['etckeeper']['git_host'] = "github.com"
default['etckeeper']['git_port'] = "22"
default['etckeeper']['git_repo'] = "etckeeper"
default['etckeeper']['git_branch'] = node['fqdn']
default['etckeeper']['git_email'] = "root@#{node['fqdn']}"

default['etckeeper']['daily_auto_commits'] = true
default['etckeeper']['special_file_warning'] = true
default['etckeeper']['commit_before_install'] = true

default['etckeeper']['use_remote'] = true
```

Usage
=====
* Add to run_list `recipe['etckeeper']` for local using etckeeper
* Set `['use_remote']` to `true` for daily auto push to remote:
 * Make ssh key and copy to `./files/default/etckeeper_key`
 * Set your `git_host` and `git_port` if your need
 * Set at atribute for git repo. For example github repo `default['etckeeper']['git_repo'] = "myuser/myrepo.git"`

Etckeeper::Commit
=================

This recipe will do two things

* In the beginning of the chef-run, check if `/etc` is unclean. If yes, fail the chef-run.
* After the chef-run, a report handler will commit the changes made to `/etc` during this chef-run.


Changelog
=========

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
