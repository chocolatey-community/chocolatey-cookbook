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

include_recipe "powershell"
uri = node['chocolatey']['Uri']

powershell "install chocolatey" do
  code "iex ((new-object net.webclient).DownloadString('#{uri}'))"
  not_if { ::File.exist?( ::File.join(node['chocolatey']['bin_path'], "chocolatey.bat") ) }
end

chocolatey "Console2" do    
    version "2.0"
    action :upgrade
end

#To latest 
chocolatey "Fiddler" do    
    action :upgrade
end

#To exsisting version
chocolatey "Fiddler" do
    version "2.3.3.4"
    action :upgrade
end

#To specific version
chocolatey "Fiddler" do    
    version "2.3.7.4"
    action :upgrade
end

chocolatey "virtualbox" do    
    version "4.2.8"
    action :remove
end

chocolatey "virtualbox" do
    action :remove
end

chocolatey "virtualbox" do	
    action :install
end

chocolatey "virtualbox" do	
    version "4.2.8"
    action :install
end

chocolatey "nofound" do	
    version "1.2.3"
    action :install
end