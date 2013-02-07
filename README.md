Description
===========

Install Chocolatey with the default recipe and manage package with LWRP

Requirements
============

Work on Windows

Resource/Provider
=================

This cookbook includes LWRPs for managing:
* chocolatey

htpasswd
--------

# Actions

- :install: Install a chocolatey package (default)
- :upgrade: Update a chocolatey package
- :remove: Uninstall a chocolatey package

# Attribute Parameters

- package_name: string or package to manage
- package: package to manage (default package_name)
- version
- source
- args: arguments to the installation


# Example

    include_recipe "chocolatey"
    
    %w{ sysinternals 7zip notepadplusplus GoogleChrome Console2}.each do |pack|
      chocolatey pack
    end
    
    %w{ bash openssh grep}.each do |pack|
      chocolatey pack do
        source "cygwin"
      end
    end


    chocolatey "DotNet4.5"

    chocolatey "PowerShell"
