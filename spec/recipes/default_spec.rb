require 'spec_helper'

describe 'chocolatey::default' do
  context 'on a supported OS' do
    let(:chef_run) {
      ChefSpec::SoloRunner.new(platform: 'windows', version: '2012')
    }

    it 'installs chocolatey if not already installed' do
      chef_run.converge(described_recipe) do
        allow(ChocolateyHelpers).to receive(:chocolatey_installed?).and_return(false)
      end
      expect(chef_run).to run_powershell_script('install chocolatey')
    end

    it 'does not install chocolatey if already installed' do
      chef_run.converge(described_recipe) do
        allow(ChocolateyHelpers).to receive(:chocolatey_installed?).and_return(true)
      end
      expect(chef_run).to_not run_powershell_script('install chocolatey')
    end

    it 'upgrades chocolatey' do
      chef_run.converge(described_recipe)
      expect(chef_run).to upgrade_chocolatey_package('chocolatey')
    end
  end

  context 'on an unsupported OS' do
    let(:chef_run) {
      ChefSpec::SoloRunner.new(platform: 'debian', version: '7.6').converge(described_recipe)
    }

    it 'does not install chocolatey' do
      chef_run.converge(described_recipe)
      expect(chef_run).to_not include_recipe('windows')
      expect(chef_run).to_not run_powershell_script('install chocolatey')
    end
  end
end
