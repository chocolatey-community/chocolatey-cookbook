default['chocolatey']['Uri'] = "https://raw.github.com/chocolatey/chocolatey/master/chocolateyInstall/InstallChocolatey.ps1"
default['chocolatey']['path'] = ::File.join( ENV['SYSTEMDRIVE'], "Chocolatey")
default['chocolatey']['bin_path'] = ::File.join( node['chocolatey']['path'], "bin")
