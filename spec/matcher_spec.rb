require 'chefspec'
require 'chefspec/berkshelf'

RSpec.describe 'chocolatey_specs::default' do
  let(:chef_run) do
    ChefSpec::SoloRunner.converge(described_recipe)
  end

  it 'installs a package' do
    expect(chef_run).to install_chocolatey('new_package').with(version: '0.1.0')
  end

  it 'upgrades a package' do
    expect(chef_run).to upgrade_chocolatey('existing_package').with(version: '0.2.0')
  end

  it 'removes a package' do
    expect(chef_run).to remove_chocolatey('trash_package')
  end
end
