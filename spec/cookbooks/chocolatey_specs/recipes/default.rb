chocolatey 'new_package' do
  version '0.1.0'
  action :install
end

chocolatey 'existing_package' do
  version '0.2.0'
  action :upgrade
end

chocolatey 'trash_package' do
  action :remove
end
