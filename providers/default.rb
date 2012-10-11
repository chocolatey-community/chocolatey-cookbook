#
# Cookbook Name:: htpasswd
# Provider:: htpasswd
# Author:: Guilhem Lettron <guilhem.lettron@youscribe.com>
#
# Copyright 20012, Societe Publica.
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

def initialize(*args)
  super
  @action = :install
end

def cmd_build
  output = ""
  if new_resource.version
    output << " -version #{new_resource.version}"
  end
  if new_resource.source
    output << " -source #{new_resource.source}"
  end
  if new_resource.args
    output << " -installArgs #{new_resource.args}"
  end
  return output
end

action :install do
  execute "install package" do
    command ::File.join(node['chocolatey']['bin_path'],"cinst.bat") + " " + new_resource.package + cmd_build
  end
end

action :upgrade do
  execute "update package" do
    command ::File.join(node['chocolatey']['bin_path'],"chocolatey.bat") + " update " + new_resource.package + cmd_build
  end
end

action :remove do
  execute "uninstall package" do
    command ::File.join(node['chocolatey']['bin_path'],"chocolatey.bat") + " uninstall " + new_resource.package + cmd_build
  end
end
