#
# Provider:: chocolatey
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
CHOCOLATEY_ROOT = "C:\\Chocolatey"
CHOCOLATEY_PATH = "#{CHOCOLATEY_ROOT}\\chocolateyinstall"
CHOCOLATEY_LIB_PATH = "#{CHOCOLATEY_ROOT}\\lib"
CHOCOLATEY_FAILED_PATH = "#{CHOCOLATEY_ROOT}\\failed"
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
  if !new_resource.args.to_s.empty?
    Chef::Log.debug "-ia \`\"#{new_resource.args}\`\""        
    output << " -ia \`\"#{new_resource.args}\`\""
  end
  return output
end

def cmd_build_without_version
  output = ""  
  if new_resource.source
    output << " -source #{new_resource.source}"
  end
  if !new_resource.args.to_s.empty?
    Chef::Log.debug "-ia \`\"#{new_resource.args}\`\""        
    output << " -ia \`\"#{new_resource.args}\`\""
  end
  return output
end


action :install do  
 if @current_resource.exists
    Chef::Log.info "#{ @new_resource } already installed - nothing to do."
  else
    converge_by("install package #{ @new_resource }") do       
       Chef::Log.debug "running chocolatey with '.\\chocolatey.ps1' install  #{new_resource.package}  #{cmd_build} -verbose" 
       
       directory CHOCOLATEY_FAILED_PATH do
        action :create
      end

       powershell "install package #{ @new_resource }" do
          cwd CHOCOLATEY_PATH          
          code <<-EOH
            $output = ""
            try
            {
              [System.Threading.Thread]::CurrentThread.CurrentCulture = ''; 
              [System.Threading.Thread]::CurrentThread.CurrentUICulture = '';
              $psargs = "install  #{new_resource.package} #{cmd_build} -verbose"
              Invoke-Expression ".\\chocolatey.ps1 $psargs"                   
            }
            catch [Exception]
            {              
              $now = Get-Date -Format "yyyyMMddhhmmss"
              $from = \"#{CHOCOLATEY_LIB_PATH}\\#{new_resource.package}.#{new_resource.version}\"              
              $to =  \"#{CHOCOLATEY_FAILED_PATH}\\$now.#{new_resource.package}.#{new_resource.version}\"              
              if((Test-Path -Path $from))
              {
                 write-host "$from" "$to"
                 move-item -force $from $to 
              }
              throw 
            }
            write-host $output
          EOH
        end       
    end
  end
end

action :upgrade do  
  if @current_resource.exists
     if hasNotSpecifiedVersion
        upgradeTolatest(new_resource.package)
     else
        if package_exists?(new_resource.package, new_resource.version)
          Chef::Log.info "package '#{new_resource.package}' is already on version '#{new_resource.version}'"
        else
          upgradeToVersion(new_resource.package, new_resource.version)
        end 
     end    
  else
    upgradeByInstallingPackageForTheFirstTime
  end  
end

action :remove do  
  if @current_resource.exists
    converge_by("uninstall package #{ @new_resource }") do
      Chef::Log.debug "'.\\chocolatey.ps1' uninstall  #{new_resource.package} #{cmd_build}"
       powershell "uninstall package #{ @new_resource }" do
          cwd CHOCOLATEY_PATH          
          code <<-EOH
            [System.Threading.Thread]::CurrentThread.CurrentCulture = ''; 
            [System.Threading.Thread]::CurrentThread.CurrentUICulture = '';
            $output = & '.\\chocolatey.ps1' uninstall  #{new_resource.package} #{cmd_build}
            write-host $output
          EOH
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
    name = "#{name}".strip
    version = "#{version}".strip
    cmd = ::File.join(node['chocolatey']['bin_path'],"chocolatey.bat") + " version "
    Chef::Log.info "Checking to see if this chocolatey package exists: '#{name}' '#{version}'"
    Chef::Log.debug "#{cmd} #{name} -localonly"
    
    IO.popen("#{cmd} #{name} -localonly").each do |line|    
      line = line.chomp
      if(line.include?('name') || line.include?('----') || line.length == 0)
        #ignore these lines
      else
        lines = line.split     
        if(lines[0] == name && lines[1] == version) 
          Chef::Log.info "Found local package '#{name}' '#{version}'"
          return true
        else
          Chef::Log.debug "package: '#{lines[0]}' '#{lines[1]}'"
        end          
      end
    end
    return false
end

def hasNotSpecifiedVersion
  return new_resource.version.nil? || new_resource.version == 0
end

def upgradePackage(name, version)
    #Install the package because it's not installed already 
    Chef::Log.info "#{ @new_resource } not installed - update will install"          
    converge_by("update package #{ @new_resource } to #{version} version ") do
      Chef::Log.debug "'.\\chocolatey.ps1' update  #{new_resource.package} -version #{version} #{cmd_build_without_version}"          
      
      directory CHOCOLATEY_FAILED_PATH do
        action :create
      end
      powershell "update package #{ @new_resource }" do
        cwd CHOCOLATEY_PATH          
        code <<-EOH
            $output = ""
            try
            {
              [System.Threading.Thread]::CurrentThread.CurrentCulture = ''; 
              [System.Threading.Thread]::CurrentThread.CurrentUICulture = '';
              $output = & '.\\chocolatey.ps1' update  #{new_resource.package} -version #{version} #{cmd_build_without_version}             
            }
            catch [Exception]
            {              
              $now = Get-Date -Format "yyyyMMddhhmmss"
              $from = \"#{CHOCOLATEY_LIB_PATH}\\#{new_resource.package}.#{new_resource.version}\"              
              $to =  \"#{CHOCOLATEY_FAILED_PATH}\\$now.#{new_resource.package}.#{new_resource.version}\"              
              if((Test-Path -Path $from))
              {
                 write-host "$from" "$to"
                 move-item -force $from $to 
              }
              throw 
            }
            write-host $output
          EOH
      end  
    end    
end

def upgradeByInstallingPackageForTheFirstTime
  #Install the package because it's not installed already 
    Chef::Log.info "#{ @new_resource } not installed - update will install"    
    if hasNotSpecifiedVersion
      version = "latest"  
    else
      version = new_resource.version        
    end   
    converge_by("update by installing package #{ @new_resource } to #{version} version ") do
      execute "update package" do
        command ::File.join(node['chocolatey']['bin_path'],"chocolatey.bat") + " update " + new_resource.package + cmd_build
      end
    end    
end

def upgradeTolatest (name)
    cmd = ::File.join(node['chocolatey']['bin_path'],"chocolatey.bat") + " version "
    Chef::Log.info "Checking to see if this chocolatey package exists: '#{name}' '#{version}'"
    IO.popen("#{cmd} #{name} -all").each do |line|    
      line = line.chomp
      upgrade = false      
      
      if(line.include?('A more recent version is available'))
         upgrade = true
      elsif(line.include?('found'))
         lines = line.split(":")
         foundVersion = "#{lines[1]}".strip
      elsif(line.include?('latest'))
         lines = line.split(":")
         latestVersion = "#{lines[1]}".strip
      elsif(line.include?('Latest version installed'))
         upgrade = false
      else 
        #ignore the line.               
      end    
      if upgrade 
        Chef::Log.info "upgrading '#{name}' from '#{foundVersion}' to '#{latestVersion}'"
        upgradePackage(name, version)
      else 
        Chef::Log.info "package '#{name}' is already on latest version '#{latestVersion}'"
      end 
    end
    return false
end

def upgradeToVersion(name, version)
    converge_by("update package #{name } to version #{version}") do
      execute "update package" do
        command ::File.join(node['chocolatey']['bin_path'],"chocolatey.bat") + " update " + " #{name} " +  " -version #{version} "  + cmd_build_without_version
      end
    end
end 
