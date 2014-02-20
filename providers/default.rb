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

use_inline_resources

# Support whyrun
def whyrun_supported?
  true
end

def load_current_resource
  @current_resource = Chef::Resource::Chocolatey.new(@new_resource.name)
  @current_resource.name(@new_resource.name)
  @current_resource.version(@new_resource.version)
  @current_resource.source(@new_resource.source)
  @current_resource.args(@new_resource.args)
  @current_resource.package(@new_resource.package)
  @current_resource.exists = true if package_exists?(@current_resource.package, @current_resource.version)
  @current_resource.upgradeable = true if upgradeable?(@current_resource.package)
#  @current_resource.installed = true if package_installed?(@current_resource.package)
end

action :install do
  if @current_resource.exists
    Chef::Log.info "#{ @current_resource.package } already installed - nothing to do."
  elsif @current_resource.version
    install_version(@current_resource.package, @current_resource.version)
  else
    install(@current_resource.package)
  end
end

action :upgrade do
  if @current_resource.upgradeable
    upgrade(@current_resource.package)
  else
    Chef::Log.info("Package #{@current_resource} already to latest version")
  end
end

action :remove do
  if @current_resource.exists
    converge_by("uninstall package #{ @current_resource.package }") do
      execute "uninstall package #{@current_resource.package}" do
        command "#{::File.join(node['chocolatey']['bin_path'], "chocolatey.bat")} uninstall  #{@new_resource.package} #{cmd_args}"
      end
    end
  else
    Chef::Log.info "#{ @new_resource } not installed - nothing to do."
  end
end

def cmd_args
  output = ''
  output += " -source #{@current_resource.source}" if @current_resource.source
  output += " -ia '#{@current_resource.args}'" unless @current_resource.args.to_s.empty?
  output
end

def package_installed?(name)
  cmd = Mixlib::ShellOut.new("#{::File.join(node['chocolatey']['bin_path'], "chocolatey.bat")} version #{name} -localonly #{cmd_args}")
  cmd.run_command
  if cmd.stdout.include?('no version')
    return false
  else
    return true
  end
#  software = cmd.stdout.split("\r\n").inject({}) {|h,s| v,k = s.split(":"); h[String(v).strip]=String(k).strip; h}
end

def package_exists?(name, version)
  if package_installed?(name)
    if version
      cmd = Mixlib::ShellOut.new("#{::File.join(node['chocolatey']['bin_path'], "chocolatey.bat")} version #{name} -localonly #{cmd_args}")
      cmd.run_command
      software = cmd.stdout.split("\r\n").reduce({}) do |h, s|
        v, k = s.split
        h[String(v).strip] = String(k).strip
        h
      end
      if software[name] == version
        return true
      else
        return false
      end
    else
      return true
    end
  else
    return false
  end
end

def upgradeable?(name)
  if @current_resource.exists
    return false
  elsif package_installed?(name)
    Chef::Log.debug("Checking to see if this chocolatey package exists: '#{name}' '#{version}'")
    cmd = Mixlib::ShellOut.new("#{::File.join(node['chocolatey']['bin_path'], "chocolatey.bat")} version #{name} #{cmd_args}")
    cmd.run_command
    if cmd.stdout.include?('Latest version installed')
      return false
    else
      return true
    end
  else
    Chef::Log.debug("Package isn't installed... we can upgrade it!")
    return true
  end
end

def install(name)
  execute "install package #{name}" do
    command "#{::File.join(node['chocolatey']['bin_path'], "chocolatey.bat")} install #{name} #{cmd_args}"
  end
end

def upgrade(name)
  execute "updating #{name} to latest" do
    command "#{::File.join(node['chocolatey']['bin_path'], "chocolatey.bat")} update #{name} #{cmd_args}"
  end
end

def install_version(name, version)
  execute "install package #{name} to version #{version}" do
    command "#{::File.join(node['chocolatey']['bin_path'], "chocolatey.bat")} install #{name} -version #{version} #{cmd_args}"
  end
end
