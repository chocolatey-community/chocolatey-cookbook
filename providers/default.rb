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

# Support whyrun
def whyrun_supported?
  true
end

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
 if @current_resource.exists
    Chef::Log.info "#{ @new_resource } already installed - nothing to do."
  else
    converge_by("install package #{ @new_resource }") do
        execute "install package" do
          command ::File.join(node['chocolatey']['bin_path'],"cinst.bat") + " " + new_resource.package + cmd_build
        end
    end
  end
end

action :upgrade do

  # if version is set then 
  #    get current version 
  #    if same 
  #       do nothing 
  #    else
  #       get last remote version 
  #         if current version < last remote 
  #           upgrade 
  #         else
  #           do nothing 
  #         end 
  #    end
  #else 
  #    if not installed 
  #       install
  #    else 
  #       get current version
  #       get last remote version 
  #         if current version < last remote 
  #           upgrade 
  #         else
  #           do nothing 
  #         end  
  #    end 
  #end 



  if @current_resource.exists
    converge_by("update package #{ @new_resource }") do
      execute "update package" do
        command ::File.join(node['chocolatey']['bin_path'],"chocolatey.bat") + " update " + new_resource.package + cmd_build
      end
    end
  else
    #chocolatey will install on upgrade so we should do the same
    Chef::Log.info "#{ @new_resource } not installed - nothing to do."
  end
end

action :remove do
  
  if @current_resource.exists
    converge_by("uninstall package #{ @new_resource }") do
       execute "uninstall package" do
        command ::File.join(node['chocolatey']['bin_path'],"chocolatey.bat") + " uninstall " + new_resource.package + cmd_build
      end
    end
  else
    Chef::Log.info "#{ @new_resource } not installed - nothing to do."
  end
end

def load_current_resource
  @current_resource = Chef::Resource::Chocolatey.new(@new_resource.name)
  @current_resource.name(@new_resource.name)
  @current_resource.version(@new_resource.version)
  @current_resource.source(@new_resource.source)
  @current_resource.source(@new_resource.args)  
  if package_exists?(@current_resource.name, @current_resource.version)    
    @current_resource.exists = true
  end
end

def package_exists?(name, version)  
    cmd = ::File.join(node['chocolatey']['bin_path'],"chocolatey.bat") + " version "
    Chef::Log.info "Checking to see if this chocolatey package exists: '#{name}' '#{version}'"
    IO.popen("#{cmd} all -localonly").each do |line|    
      line = line.chomp
      if(line.include?('name') || line.include?('----') || line.length == 0)
        #ignore these lines
      else
        lines = line.split     
        if(lines[0] == name && lines[1] == version) 
          Chef::Log.info "Found local package '#{name}' '#{version}'"
          return true
        else
          Chef::Log.info "package: '#{lines[0]}' '#{lines[1]}'"
        end          
      end
    end
    return false
end
