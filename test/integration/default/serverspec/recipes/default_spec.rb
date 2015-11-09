require 'spec_helper'

choco_exe = File.join(ENV['ProgramData'], 'chocolatey', 'bin', 'choco.exe')
chocolatey_nupkg = File.join(
  ENV['ProgramData'], 'chocolatey', 'lib', 'chocolatey', 'chocolatey.nupkg'
)

RSpec.describe command(choco_exe) do
  its(:stdout) { should match(/Chocolatey/) }
end

RSpec.describe command("#{choco_exe} list -l chocolatey") do
  its(:stdout) { should match(/1 packages installed\./) }
end

RSpec.describe file(chocolatey_nupkg) do
  it { should exist }
end
