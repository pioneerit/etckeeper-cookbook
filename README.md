Description
===========
Install and configure etckeeper. Add cron task for every day commit & push changes to remote repo.
Thanks to [alekschumakov88](https://github.com/alekschumakov88), who created the first version of this cookbook.

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
1.0.1
-----
* Merge with TYPO3
* Remove unnecessary attributes
* Remove manual adding cron task - only change cron.daily screept if use remote
* Change from post-install push - to commit push
* Remove init from config. Now remote checking on etcekeeper commit hook
* Few renames for simple code view