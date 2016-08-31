name             'chocolatey'
maintainer       'Guilhem Lettron'
maintainer_email 'guilhem.lettron@youscribe.com'
license          'Apache 2.0'
description      'Install chocolatey and packages on Windows'
long_description 'Installs the Chocolatey package manager for Windows and provides a Chef resource for installing nuget packages from https://chocolatey.org/'
version          '1.0.2'

source_url 'https://github.com/chocolatey/chocolatey-cookbook' if defined?(:source_url)
issues_url 'https://github.com/chocolatey/chocolatey-cookbook/issues' if defined?(:issues_url)

supports 'windows'

depends 'windows', '~> 1.38'
depends 'compat_resource'
