#
# Cookbook Name:: chocolatey
# recipe:: default
# Author:: Guilhem Lettron <guilhem.lettron@youscribe.com>
#
# Copyright 2012, Societe Publica.
# Copyright 2015, Doug Ireton
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
unless node['platform_family'] == 'windows'
  return "Chocolatey install not supported on #{node['platform_family']}"
end

Chef::Resource.send(:include, Chocolatey::Helpers)

install_ps1 = File.join(Chef::Config['file_cache_path'], 'install.ps1')

template install_ps1 do
  action :create
  backup false
  source 'InstallChocolatey.ps1.erb'
  variables :download_url => node['chocolatey']['install_vars']['chocolateyDownloadUrl']
end

powershell_script 'Install Chocolatey' do
  action :run
  environment node['chocolatey']['install_vars']
  cwd Chef::Config['file_cache_path']
  code install_ps1
  notifies :run, "ruby_block[track-path-chocolatey]", :immediately
  not_if { chocolatey_installed? && (node['chocolatey']['upgrade'] == false) }
end

ruby_block "track-path-chocolatey" do
  action :nothing
  block { ENV['PATH'] = env_path(ENV['PATH']) }
end
