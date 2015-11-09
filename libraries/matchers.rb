#
# Cookbook Name:: chocolatey
# Library:: matchers
#

# These can be used when testing for chefspec.
# Example:
#   Recipe:
#     chocolatey 'cool_package'
#   ChefSpec:
#     expect(chef_run).to install_chocolatey('cool_package')
#
if defined?(ChefSpec)
  ChefSpec.define_matcher(:chocolatey)

  def install_chocolatey(name)
    ChefSpec::Matchers::ResourceMatcher.new(:chocolatey, :install, name)
  end

  def upgrade_chocolatey(name)
    ChefSpec::Matchers::ResourceMatcher.new(:chocolatey, :upgrade, name)
  end

  def remove_chocolatey(name)
    ChefSpec::Matchers::ResourceMatcher.new(:chocolatey, :remove, name)
  end
end
