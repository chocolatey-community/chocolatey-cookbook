RSpec.describe 'chocolatey::default' do
  context 'on Windows 2012r2' do
    cached(:windows_node) do
      # use call original as per http://www.relishapp.com/rspec/rspec-mocks/v/3-3/docs/configuring-responses/calling-the-original-implementation#%60and-call-original%60-can-configure-a-default-response-that-can-be-overriden-for-specific-args
      allow(ENV).to receive(:[]).and_call_original
      allow(ENV).to receive(:[]).with('TEMP').and_return('c:/windows/temp')
      allow(ENV).to receive(:fetch).with('ChocolateyInstall').and_return('C:\ProgramData\chocolatey')

      ChefSpec::SoloRunner.new(
        platform: 'windows', version: '2012R2'
      ).converge(described_recipe)
    end

    let(:nuget_package_path) do
      File.join(
        Chef::Config['file_cache_path'], 'chocolatey.nupkg'
      )
    end

    let(:downloaded_package) { windows_node.remote_file(nuget_package_path) }

    let(:extract_dir) { 'c:/windows/temp/chocolatey' }
    let(:windows_zipfile) { windows_node.windows_zipfile(extract_dir) }
    let(:powershell_script) { windows_node.powershell_script('Install Chocolatey') }
    let(:ruby_block) { windows_node.ruby_block('Ensure chocolatey.nupkg is in chocolatey/lib/chocolatey/') }

    it 'Downloads the latest chocolatey.nupkg to the file_cache_path' do
      expect(windows_node).to create_remote_file(nuget_package_path).with(
        source: 'https://chocolatey.org/api/v2/package/chocolatey/',
        backup: false
      )
    end

    it 'remote_file notifies windows_zipfile to unzip the downloaded Chocolatey package' do
      expect(downloaded_package).to notify("windows_zipfile[#{extract_dir}]").to(:unzip).immediately
    end

    it 'remote_file notifies powershell_script to run the Chocolatey install script' do
      expect(downloaded_package).to notify('powershell_script[Install Chocolatey]').to(:run).immediately
    end

    it 'remote_file notifies ruby_block to mv chocolatey.nupkg to lib/chocolatey/' do
      expect(downloaded_package).to notify(
        'ruby_block[Ensure chocolatey.nupkg is in chocolatey/lib/chocolatey/]'
      ).to(:run).immediately
    end

    it 'windows_zipfile does not unzip the Chocolatey package unless notified' do
      expect(windows_zipfile).to do_nothing
    end

    it 'windows_zipfile overwrites the extract directory' do
      expect(windows_zipfile.overwrite).to eql(true)
    end

    it "windows_zipfile extracts from Chef's file_cache_path to %TEMP%/chocolatey directory" do
      expect(windows_zipfile.source).to eq('c:/chef/cache/chocolatey.nupkg')
      expect(windows_zipfile.path).to eq('c:/windows/temp/chocolatey')
    end

    it 'powershell_script does not install Chocolatey unless a new chocolatey.nupkg has been downloaded' do
      expect(powershell_script).to do_nothing
    end

    it 'runs the chocolateyInstall.ps1 script from the extracted Chocolatey tools directory' do
      expect(powershell_script.cwd).to eq('c:/windows/temp/chocolatey/tools')
      expect(powershell_script.code).to eq('c:/windows/temp/chocolatey/tools/chocolateyInstall.ps1')
    end

    it 'ruby_block does not run chocolatey.nupkg file mv unless notified' do
      expect(ruby_block).to do_nothing
    end
  end
end
