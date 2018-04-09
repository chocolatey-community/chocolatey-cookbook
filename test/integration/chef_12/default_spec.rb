choco_exe = File.join(ENV['ProgramData'], 'chocolatey', 'bin', 'choco.exe')
chocolatey_nupkg = File.join(
  ENV['ProgramData'], 'chocolatey', 'lib', 'chocolatey', 'chocolatey.nupkg'
)

describe command(choco_exe) do
  its(:stdout) { should match(/Chocolatey/) }
end

describe command("#{choco_exe} list -l chocolatey") do
  its(:stdout) { should match(/[1-9] packages installed\./) }
end

describe command("#{choco_exe} --version") do
  its(:stdout) { should eq("0.10.5\r\n") }
end

describe file(chocolatey_nupkg) do
  it { should exist }
end
