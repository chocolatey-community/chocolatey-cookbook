if node['platform_family'] == 'windows'
  default['chocolatey']['Uri']      = 'https://chocolatey.org/install.ps1'
  default['chocolatey']['path']     = ::File.join(ENV['SYSTEMDRIVE'], 'Chocolatey')
  default['chocolatey']['bin_path'] = ::File.join(node['chocolatey']['path'], 'bin')
  default['chocolatey']['upgrade']  = true
end
