#
# Cookbook Name:: chocolatey
# recipe:: default
# Author:: Guilhem Lettron <guilhem.lettron@youscribe.com>
#
# Copyright 2012, Societe Publica.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

return 'platform not supported' if node['platform_family'] != 'windows'
include_recipe 'windows'

# ::Chef::Recipe.send(:include, Chef::Mixin::PowershellOut)
::Chef::Resource::RubyBlock.send(:include, Chef::Mixin::PowershellOut)

# Add ability to download Chocolatey install script behind a proxy
# This also works if you are not behind a proxy
command = <<-EOS
  $wc = New-Object Net.WebClient
  $wp=[system.net.WebProxy]::GetDefaultProxy()
  $wp.UseDefaultCredentials=$true
  $wc.Proxy=$wp
  Invoke-Expression ($wc.DownloadString('#{node['chocolatey']['Uri']}'))
EOS

ruby_block 'install chocolatey' do
  block do
    powershell_out!(command)
  end
  not_if { ChocolateyHelpers.chocolatey_installed? }
end

ruby_block "reset ENV['ChocolateyInstall']" do
  block do
    cmd = powershell_out!("[System.Environment]::GetEnvironmentVariable('ChocolateyInstall', 'MACHINE')")
    ENV['ChocolateyInstall'] = cmd.stdout.chomp
    Chef::Log.info("ChocolateyInstall is '#{ENV['ChocolateyInstall']}'")
  end
end

ruby_block "update ENV['Path']" do
  block do
    ENV['PATH'] += File::PATH_SEPARATOR unless ENV['PATH'].end_with?(File::PATH_SEPARATOR)
    ENV['PATH'] += ::File.join(ChocolateyHelpers.chocolatey_install, 'bin')
  end
end

# Issue #1: Cygwin "setup.log" size
file 'cygwin log' do
  path 'C:/cygwin/var/log/setup.log'
  action :delete
end

chocolatey 'chocolatey' do
  action :upgrade
  only_if { node['chocolatey']['upgrade'] }
end
