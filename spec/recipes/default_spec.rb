RSpec.describe 'chocolatey::default' do
  context 'on Windows' do
    let(:proxy) { nil }
    let(:proxy_config) { nil }
    let(:proxy_env) { nil }

    let(:windows_node) do
      # use call original as per http://www.relishapp.com/rspec/rspec-mocks/v/3-3/docs/configuring-responses/calling-the-original-implementation#%60and-call-original%60-can-configure-a-default-response-that-can-be-overriden-for-specific-args
      allow(ENV).to receive(:[]).and_call_original
      allow(ENV).to receive(:fetch).with('ChocolateyInstall').and_return('C:\ProgramData\chocolatey')
      allow(ENV).to receive(:[]).with('https_proxy').and_return(proxy_env)

      allow(Chef::Config).to receive(:[]).and_call_original
      allow(Chef::Config).to receive(:[]).with('https_proxy').and_return(proxy_config)
      allow(Chef::Config).to receive(:[]).with('file_cache_path').and_return('c:/chef/cache')
      ChefSpec::SoloRunner.new(
        platform: 'windows'
      ).converge(described_recipe)
    end

    let(:install_ps1) do
      File.join(
        Chef::Config['file_cache_path'], 'chocolatey-install.ps1'
      )
    end

    let(:install_template) { windows_node.template(install_ps1) }
    let(:powershell_script) { windows_node.powershell_script('Install Chocolatey') }
    let(:ruby_block) { windows_node.ruby_block('set proxy') }

    it 'Creates the chocolatey install_ps1 to the file_cache_path' do
      expect(windows_node).to create_cookbook_file(install_ps1).with(
        backup: false
      )
    end

    let(:download_package) { windows_node.cookbook_file(install_ps1) }

    it 'powershell_script does not set chocolateyProxyLocation' do
      expect(powershell_script.environment['chocolateyProxyLocation']).to eq(proxy)
    end

    it 'runs the install.ps1 script from the chef file cache directory' do
      expect(powershell_script.cwd).to eq('c:/chef/cache')
      expect(powershell_script.code).to eq('c:/chef/cache/chocolatey-install.ps1')
    end

    context 'proxy is configured in Chef::Config' do
      let(:proxy) { 'chef_config_proxy' }
      let(:proxy_config) { proxy }

      it 'powershell_script adds configured proxy to chocolateyProxyLocation' do
        expect(powershell_script.environment['chocolateyProxyLocation']).to eq(proxy)
      end
    end

    context 'proxy is configured in environment' do
      let(:proxy) { 'chef_config_proxy' }
      let(:proxy_env) { proxy }

      it 'powershell_script adds proxy environment variable to chocolateyProxyLocation' do
        expect(powershell_script.environment['chocolateyProxyLocation']).to eq(proxy)
      end
    end
  end
end
