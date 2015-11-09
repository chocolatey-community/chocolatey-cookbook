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

remote_file install_ps1 do
  source node['chocolatey']['url']
  backup false
  notifies :run, 'powershell_script[Install Chocolatey]', :immediately
  not_if { chocolatey_installed? && (node['chocolatey']['upgrade'] == false) }
end

powershell_script 'Install Chocolatey' do
  action :nothing
  environment node['chocolatey']['install_vars']
  cwd Chef::Config['file_cache_path']
  code install_ps1
end
