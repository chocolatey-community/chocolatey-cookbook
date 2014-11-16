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
    "\"#{::File.join(chocolatey_install, 'bin', 'choco')}\""
  end

  # Check if Chocolatey is installed
  def self.chocolatey_installed?
    return @is_chocolatey_installed if @is_chocolatey_installed
    return false if chocolatey_install.nil?

    cmd = Mixlib::ShellOut.new("#{chocolatey_executable} /?")
    cmd.run_command
    @is_chocolatey_installed = (cmd.exitstatus == 0)
  end

  def self.package_installed?(name, cmd_args)
    cmd = Mixlib::ShellOut.new("#{::ChocolateyHelpers.chocolatey_executable} version #{name} -localonly #{cmd_args}")
    cmd.run_command

    cmd.exitstatus == 0
  end

  def self.package_exists?(name, version, cmd_args)
    return false unless ::ChocolateyHelpers.package_installed?(name, cmd_args)
    return true unless version

    cmd = Mixlib::ShellOut.new("#{::ChocolateyHelpers.chocolatey_executable} version #{name} -localonly #{cmd_args}")
    cmd.run_command
    software = cmd.stdout.split("\r\n").each_with_object({}) do |s, h|
      v, k = s.split
      h[String(v).strip] = String(k).strip
      h
    end

    software[name] == version
  end

  def self.upgradeable?(name)
    return false unless @current_resource.exists
    unless ::ChocolateyHelpers.package_installed?(name, cmd_args)
      Chef::Log.debug("Package isn't installed... we can upgrade it!")
      return true
    end

    Chef::Log.debug("Checking to see if this chocolatey package is installed/upgradable: '#{name}'")
    cmd = Mixlib::ShellOut.new("#{::ChocolateyHelpers.chocolatey_executable} version #{name} #{cmd_args}")
    cmd.run_command
    !cmd.stdout.include?('Latest version installed')
  end
end
