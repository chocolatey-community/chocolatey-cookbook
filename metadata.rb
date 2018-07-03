name             'chocolatey'
maintainer       'Guilhem Lettron'
maintainer_email 'guilhem.lettron@youscribe.com'
license          'Apache-2.0'
description      'Install Chocolatey on Windows'
long_description 'Installs the Chocolatey package manager for Windows.'
version          '2.0.0'

source_url 'https://github.com/chocolatey/chocolatey-cookbook'
issues_url 'https://github.com/chocolatey/chocolatey-cookbook/issues'

supports 'windows'

chef_version '>= 12.7' if respond_to?(:chef_version)
