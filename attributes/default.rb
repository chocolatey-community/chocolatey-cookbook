if node['platform_family'] == "windows"
  default['chocolatey']['path'] = ::File.join( ENV['SYSTEMDRIVE'], "Chocolatey")
  default['chocolatey']['bin_path'] = ::File.join( node['chocolatey']['path'], "bin")
end
