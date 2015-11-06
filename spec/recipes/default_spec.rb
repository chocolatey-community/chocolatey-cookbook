RSpec.describe 'chocolatey::default' do
  context 'on Windows 2012r2' do
    cached(:windows_node) do
      # use call original as per http://www.relishapp.com/rspec/rspec-mocks/v/3-3/docs/configuring-responses/calling-the-original-implementation#%60and-call-original%60-can-configure-a-default-response-that-can-be-overriden-for-specific-args
      allow(ENV).to receive(:[]).and_call_original
      allow(ENV).to receive(:fetch).with('ChocolateyInstall').and_return('C:\ProgramData\chocolatey')

      ChefSpec::SoloRunner.new(
        platform: 'windows', version: '2012R2'
      ).converge(described_recipe)
    end

    let(:install_ps1) do
      File.join(
        Chef::Config['file_cache_path'], 'install.ps1'
      )
    end

    let(:downloaded_package) { windows_node.remote_file(install_ps1) }
    let(:powershell_script) { windows_node.powershell_script('Install Chocolatey') }
    let(:ruby_block) { windows_node.ruby_block('set proxy') }

    it 'Downloads the chocolatey install.ps1 to the file_cache_path' do
      expect(windows_node).to create_remote_file(install_ps1).with(
        source: 'https://chocolatey.org/install.ps1',
        backup: false
      )
    end

    it 'remote_file notifies powershell_script to run the Chocolatey install script' do
      expect(downloaded_package).to notify('powershell_script[Install Chocolatey]').to(:run).immediately
    end

    it 'remote_file notifies ruby_block to set chocolatey proxy variables' do
      expect(downloaded_package).to notify(
        'ruby_block[set proxy]'
      ).to(:run).immediately
    end

    it 'powershell_script does not install Chocolatey unless a new install.ps1 has been downloaded' do
      expect(powershell_script).to do_nothing
    end

    it 'runs the install.ps1 script from the chef file cache directory' do
      expect(powershell_script.cwd).to eq('c:/chef/cache')
      expect(powershell_script.code).to eq('c:/chef/cache/install.ps1')
    end

    it 'ruby_block does not set proxy unless notified' do
      expect(ruby_block).to do_nothing
    end
  end
end
