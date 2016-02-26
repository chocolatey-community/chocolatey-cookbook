chocolatey 'git.install' do
  options('params' => "'/GitOnlyOnPath'")
end

git File.join(ENV['TEMP'], 'chocolatey-cookbook') do
  repository 'https://github.com/chocolatey/chocolatey-cookbook'
  revision 'master'
  action :sync
end
