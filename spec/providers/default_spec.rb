require 'spec_helper'

describe 'chocolatey_test::install_package' do
  context 'on a supported OS' do
    let(:chef_run) {
      ChefSpec::SoloRunner.new(
        platform: 'windows',
        version: '2012',
        step_into: 'chocolatey'
      ).converge(described_recipe)
    }

    it 'installs package' do
      expect(chef_run).to run_execute('install package test-package').with(command: /[^\"].+\/bin\/choco\" install test-package/)
    end
  end
end

describe 'chocolatey_test::remove_package' do
  context 'on a supported OS' do
    let(:chef_run) {
      ChefSpec::SoloRunner.new(
        platform: 'windows',
        version: '2012',
        step_into: 'chocolatey'
      )
    }

    it 'removes package' do
      chef_run.converge(described_recipe) do
        allow(ChocolateyHelpers).to receive(:package_installed?).and_return(true)
        allow(ChocolateyHelpers).to receive(:package_exists?).and_return(true)
      end
      expect(chef_run).to run_execute('uninstall package test-package').with(command: /[^\"].+\/bin\/choco\" uninstall test-package/)
    end
  end
end

describe 'chocolatey_test::upgrade_package' do
  context 'on a supported OS' do
    let(:chef_run) {
      ChefSpec::SoloRunner.new(
        platform: 'windows',
        version: '2012',
        step_into: 'chocolatey'
      )
    }

    it 'upgrades package' do
      chef_run.converge(described_recipe) do
        allow(ChocolateyHelpers).to receive(:upgradeable?).and_return(true)
      end
      expect(chef_run).to run_execute('updating test-package to latest').with(command: /[^\"].+\/bin\/choco\" update test-package/)
    end
  end
end
