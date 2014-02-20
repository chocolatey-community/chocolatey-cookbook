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

include_recipe 'powershell'

powershell 'install chocolatey' do
  code "iex ((new-object net.webclient).DownloadString('#{node['chocolatey']['Uri']}'))"
  not_if { ::File.exist?(::File.join(node['chocolatey']['bin_path'], 'chocolatey.bat')) }
end

file 'cygwin log' do
  path 'C:/cygwin/var/log/setup.log'
  action :delete
end

chocolatey 'chocolatey' do
  action :upgrade if node['chocolatey']['upgrade']
end
