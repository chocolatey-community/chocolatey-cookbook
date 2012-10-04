Description
===========

Manage an htpasswd file.
If htpasswd exe isn't found, we install a python implementation.

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

chocolatey "sysinternals"

chocolatey "7zip"

chocolatey "notepadplusplus"

chocolatey "GoogleChrome"

chocolatey "Console2"

chocolatey "bash" do
  source "cygwin"
end

chocolatey "openssh" do
  source "cygwin"
end

chocolatey "grep" do
  source "cygwin"
end

chocolatey "DotNet4.5"

chocolatey "PowerShell"
