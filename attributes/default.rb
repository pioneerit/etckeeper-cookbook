default['etckeeper']['dir'] = '/etc/etckeeper'
default['etckeeper']['config'] = "#{node['etckeeper']['dir']}/etckeeper.conf"
default['etckeeper']['vcs'] = 'git'
default['etckeeper']['daily_auto_commits'] = true
default['etckeeper']['special_file_warning'] = true
default['etckeeper']['commit_before_install'] = true
default['etckeeper']['use_remote'] = false
default['etckeeper']['git_host'] = 'github.com'
default['etckeeper']['git_port'] = 22
default['etckeeper']['git_repo'] = 'etckeeper'
default['etckeeper']['git_branch'] = node['fqdn']
default['etckeeper']['git_email'] = "root@#{node['fqdn']}"

case node['platform']
when 'centos', 'redhat', 'amazon', 'scientific', 'fedora'
  default['etckeeper']['high_pckg_man'] = 'yum'
  default['etckeeper']['low_pckg_man'] = 'rpm'
when 'ubuntu', 'debian'
  default['etckeeper']['high_pckg_man'] = 'apt'
  default['etckeeper']['low_pckg_man'] = 'dpkg'
when 'gentoo'
  default['etckeeper']['high_pckg_man'] = 'emerge'
  default['etckeeper']['low_pckg_man'] = 'qlist'
end
