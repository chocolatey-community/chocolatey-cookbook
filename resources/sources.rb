#
# Author:: George Vanburgh (gvanburgh@bloomberg.net)
# Cookbook Name:: chocolatey
# Resource:: sources
#
# Copyright 2017, Bloomberg L.P.
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

include ::Chocolatey::Helpers

property :sources, kind_of: Hash

default_action :manage

load_current_value do
  require 'nokogiri'

  current_value_does_not_exist! unless ::File.exist?(chocolatey_config_file)

  config = ::File.open(chocolatey_config_file) { |f| Nokogiri::XML(f) }

  sources_config = config.xpath('/chocolatey/sources/source')
  configured_sources = Hash[sources_config.map { |s| [s['id'], s['value']] }]

  current_value_does_not_exist! if configured_sources.nil?

  sources configured_sources
end

action :manage do
  converge_if_changed :sources do
    missing_sources = (new_resource.sources.to_a - current_resource.sources.to_a).to_h
    superfluous_sources = (current_resource.sources.to_a - new_resource.sources.to_a).to_h

    # No point in removing a source if we're about to modify it
    superfluous_sources.delete_if { |key, _| missing_sources.key?(key) }

    superfluous_sources.each do |id_to_remove, _|
      chocolatey_source id_to_remove do
        action :remove
      end
    end

    missing_sources.each do |id_to_update, source|
      chocolatey_source id_to_update do
        action :add
        source source
      end
    end
  end
end
