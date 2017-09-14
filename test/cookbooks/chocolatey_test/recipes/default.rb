chocolatey 'git.install' do
  options('params' => "'/GitOnlyOnPath'")
end

git File.join(ENV['TEMP'], 'chocolatey-cookbook') do
  repository 'https://github.com/chocolatey/chocolatey-cookbook'
  revision 'master'
  action :sync
end

test_sources = {
  'test_source' => 'http://test.com/api/',
  'test_source2' => '\\\\testing\\folder',
}

chocolatey_sources 'chocolatey.sources' do
  sources test_sources
end
