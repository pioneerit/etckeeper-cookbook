Description
===========
Install and configure etckeeper. Add cron task for every day commit & push changes to remote repo.
Thanks to [alekschumakov88](https://github.com/alekschumakov88), who created the first version of this cookbook.

Requirements
============
recipe['cron']

Attributes
==========
```ruby
default['etckeeper']['git_host'] = "github.com"
default['etckeeper']['git_port'] = "22"
default['etckeeper']['git_repo'] = "etckeeper"
default['etckeeper']['git_branch'] = node['fqdn']

default['etckeeper']['git_remote_enabled'] = true
```

Usage
=====
* If you do not set `['git_remote_enabled']` to `false`:
 * Make key and copy to ./files/default as etckeeper_key
 * Set at atribute for git repo. For example `default['etckeeper']['git_repo'] = "myuser/myrepo.git"`
* Add to run_list `recipe['etckeeper']`

TODO
=====
1. Add more info
2. Make more flexible work with keys. Change files to attributes or data_bags
