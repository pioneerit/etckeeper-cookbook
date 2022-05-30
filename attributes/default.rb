default['etckeeper']['handler_path'] = "#{File.expand_path(File.join(Chef::Config[:file_cache_path], '..'))}/handlers"
default['etckeeper']['dir'] = '/etc/etckeeper'
default['etckeeper']['config'] = ::File.join(node['etckeeper']['dir'], 'etckeeper.conf')
default['etckeeper']['config_file']['VCS'] = 'git'
# Setting any option to '1' means it will activate
default['etckeeper']['config_file']['AVOID_DAILY_AUTOCOMMITS'] = 1
default['etckeeper']['config_file']['AVOID_COMMIT_BEFORE_INSTALL'] = 1
default['etckeeper']['ssh']['key']['cookbook'] = 'etckeeper'
default['etckeeper']['git_email'] = "root@#{node['fqdn']}"
# Remote setting
default['etckeeper']['git_host']
default['etckeeper']['git_port']
default['etckeeper']['git_repo']
default['etckeeper']['git_branch']
default['etckeeper']['config_file']['PUSH_REMOTE'] = ''

case node['platform']
when 'centos', 'redhat', 'amazon', 'scientific', 'fedora'
  default['etckeeper']['high_pckg_man'] = 'yum'
  default['etckeeper']['low_pckg_man'] = 'rpm'
  default['etckeeper']['config_file']['HIGHLEVEL_PACKAGE_MANAGER'] = 'yum'
  default['etckeeper']['config_file']['LOWLEVEL_PACKAGE_MANAGER'] = 'rpm'
when 'ubuntu', 'debian'
  default['etckeeper']['high_pckg_man'] = 'apt'
  default['etckeeper']['low_pckg_man'] = 'dpkg'
  default['etckeeper']['config_file']['HIGHLEVEL_PACKAGE_MANAGER'] = 'apt'
  default['etckeeper']['config_file']['LOWLEVEL_PACKAGE_MANAGER'] = 'dpkg'
when 'gentoo'
  default['etckeeper']['high_pckg_man'] = 'emerge'
  default['etckeeper']['low_pckg_man'] = 'qlist'
  default['etckeeper']['config_file']['HIGHLEVEL_PACKAGE_MANAGER'] = 'emerge'
  default['etckeeper']['config_file']['LOWLEVEL_PACKAGE_MANAGER'] = 'qlist'
when 'pld'
  default['etckeeper']['high_pckg_man'] = 'poldek'
  default['etckeeper']['low_pckg_man'] = 'rpm'
  default['etckeeper']['config_file']['HIGHLEVEL_PACKAGE_MANAGER'] = 'poldek'
  default['etckeeper']['config_file']['LOWLEVEL_PACKAGE_MANAGER'] = 'rpm'
end

# Backward compatibility
default['etckeeper']['config_file']['VCS'] = node['etckeeper']['vcs'] if node['etckeeper']['vcs']
default['etckeeper']['config_file']['AVOID_DAILY_AUTOCOMMITS'] = 1 unless node['etckeeper']['daily_auto_commits']
default['etckeeper']['config_file']['AVOID_SPECIAL_FILE_WARNING'] = 1 unless node['etckeeper']['special_file_warning']
default['etckeeper']['config_file']['AVOID_COMMIT_BEFORE_INSTALL'] = 1 unless node['etckeeper']['commit_before_install']
unless node['etckeeper']['git_repo'].empty? ||
    node['etckeeper']['git_host'].empty? ||
    node['etckeeper']['git_branch'].empty?
  default['etckeeper']['config_file']['PUSH_REMOTE'] = 'origin'
  default['etckeeper']['git_branch'] = node['fqdn']
end
