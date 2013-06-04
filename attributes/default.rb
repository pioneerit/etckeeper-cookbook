default['etckeeper']['packages']   = %w{etckeeper git}
default['etckeeper']['dir']        = "/etc/etckeeper"
default['etckeeper']['config']     = "#{node['etckeeper']['dir']}/etckeeper.conf"
default['etckeeper']['vcs']        = "git"
default['etckeeper']['git_remote_enabled']   = true
default['etckeeper']['git_host']   = "github.com"
default['etckeeper']['git_port']   = 22
default['etckeeper']['git_repo']   = "etckeeper"
default['etckeeper']['git_branch'] = node['fqdn']

case node['platform']
when "centos", "redhat", "amazon", "scientific","fedora"
  default['etckeeper']['high_pckg_man'] = "yum"
  default['etckeeper']['low_pckg_man'] = "rpm"
when "ubuntu","debian"
  default['etckeeper']['high_pckg_man'] = "apt"
  default['etckeeper']['low_pckg_man'] = "dpkg"
end
