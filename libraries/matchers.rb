if defined?(ChefSpec)
  def install_chocolatey_package(resource_name)
    ChefSpec::Matchers::ResourceMatcher.new(:chocolatey, :install, resource_name)
  end

  def upgrade_chocolatey_package(resource_name)
    ChefSpec::Matchers::ResourceMatcher.new(:chocolatey, :upgrade, resource_name)
  end

  def remove_chocolatey_package(resource_name)
    ChefSpec::Matchers::ResourceMatcher.new(:chocolatey, :remove, resource_name)
  end
end
