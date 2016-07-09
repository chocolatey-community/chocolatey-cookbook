source 'https://rubygems.org'

gem 'rake', '~> 10.4'
gem 'berkshelf', '~> 4.0'
gem 'stove', '~> 3.2'

group :test do
  gem 'chefspec', '~> 4.4'
  gem 'foodcritic', '~> 5.0'
  gem 'rubocop', '~> 0.34'
end

group :integration do
  gem 'kitchen-vagrant', '~> 0.19'
  gem 'kitchen-inspec', :github => "mwrock/kitchen-inspec", :branch => "winrm-v2"
  gem "test-kitchen", :github => "test-kitchen", :branch => "winrm-v2"
  gem "train", :github => "chef/train", :branch => "winrm-v2"
  gem "winrm", :github => "winrb/winrm", :branch => "winrm-v2"
  gem "winrm-fs", :github => "winrb/winrm-fs", :branch => "winrm-v2"
  gem "winrm-elevated", :github => "winrb/winrm-elevated", :branch => "winrm-v2"
end
