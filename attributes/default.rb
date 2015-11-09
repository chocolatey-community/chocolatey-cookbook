default['chocolatey']['url'] = 'https://chocolatey.org/install.ps1'
default['chocolatey']['upgrade'] = true

# Chocolatey install.ps1 env vars. See https://chocolatey.org/install.ps1
default['chocolatey']['install_vars'].tap do |env|
  env['chocolateyProxyLocation'] = Chef::Config['https_proxy'] || ENV['https_proxy']
  env['chocolateyProxyUser'] = nil
  env['chocolateyProxyPassword'] = nil
  env['chocolateyVersion'] = nil
  env['chocolateyDownloadUrl'] = nil
  env['chocolateyUseWindowsCompression'] = nil
end
