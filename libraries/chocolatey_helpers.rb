module ChocolateyHelpers
  # Get the ChocolateyInstall directory from the environment.
  def self.chocolatey_install
    ci_keys = ENV.keys.grep(/^ChocolateyInstall$/i)
    ci_keys.count > 0 ? ENV[ci_keys.first] : nil
  end

  # The Chocolatey command.
  #
  # Reference: https://github.com/chocolatey/chocolatey-cookbook/pull/16#issuecomment-47975896
  def self.chocolatey_executable
    "#{::File.join(self.chocolatey_install, 'bin', 'choco')}".gsub(::File::SEPARATOR, ::File::ALT_SEPARATOR || ::File::SEPARATOR)
  end

  # Check if Chocolatey is installed
  def self.chocolatey_installed?
    return @is_chocolatey_installed if @is_chocolatey_installed
    return false if chocolatey_install.nil?

    cmd = Mixlib::ShellOut.new("#{chocolatey_executable} /?")
    cmd.run_command
    @is_chocolatey_installed = (cmd.exitstatus == 0)
  end
end
