if node[:platform_family] == 'windows'
  default[:chocolatey][:uri]      = 'https://chocolatey.org/install.ps1'
  default[:chocolatey][:path]     = ::File.join(ENV['SYSTEMDRIVE'], 'ProgramData', 'chocolatey')
  default[:chocolatey][:bin] = ::File.join(node[:chocolatey][:path], 'bin', 'chocolatey.exe')
  default[:chocolatey][:upgrade]  = true
end
