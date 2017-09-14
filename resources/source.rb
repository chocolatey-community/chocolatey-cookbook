#
# Author:: Blair Hamilton (bhamilton@draftkings.com>)
# Author:: Jonathan Morley (morley.jonathan@gmail.com>)
# Cookbook Name:: chocolatey
# Resource:: source
#
# Copyright 2015, Blair Hamilton
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
require 'chef/mixin/shell_out'
include Chef::Mixin::ShellOut

include ::Chocolatey::Helpers

property :name, kind_of: String, name_attribute: true
property :source, kind_of: String

default_action :add

load_current_value do
  require 'nokogiri'

  current_value_does_not_exist! unless ::File.exist?(chocolatey_config_file)

  config = ::File.open(chocolatey_config_file) { |f| Nokogiri::XML(f) }

  config_source = config.xpath("/chocolatey/sources/source[@id='#{name}']").first
  current_value_does_not_exist! if config_source.nil?

  source config_source.attribute('value').text
end

action :add do
  converge_if_changed :source do
    choco_cmd = 'choco source add'
    choco_cmd << " --name \"#{new_resource.name}\"" if new_resource.name
    choco_cmd << " --source \"#{new_resource.source}\"" if new_resource.source

    execute 'add choco source' do
      action :run
      command choco_cmd
    end
  end
end

action :remove do
  choco_cmd = 'choco source remove'
  choco_cmd << " --name \"#{new_resource.name}\"" if new_resource.name

  execute 'remove choco source' do
    action :run
    command choco_cmd
  end
end
