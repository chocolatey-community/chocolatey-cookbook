describe command('C:\ProgramData\chocolatey\bin\chocolatey.exe') do
  its('stdout') { should match(/Chocolatey/) }
end

describe command('C:\ProgramData\chocolatey\bin\chocolatey.exe --version') do
  its('stdout.strip') { should cmp '0.11.3' }
end

describe file('C:\ProgramData\chocolatey\lib\chocolatey\chocolatey.nupkg') do
  it { should exist }
end

describe chocolatey_package('chocolatey') do
  it { should be_installed }
  its('version') { should eq '0.11.3' }
end
