Chocolatey cookbook
===================

Install Chocolatey with the default recipe and manage packages with a handy
resource/provider.

Requirements
------------

-   Microsoft Windows -- It can be safely be depended on by other platforms as
    long as no recipes are used.
-   Chef 11.6 or greater -- If you use an older Chef and cannot upgrade then
    use version 0.1.0 instead.

Notes
-----

As of Chocolatey version
[0.9.8.24](https://github.com/chocolatey/chocolatey/blob/master/CHANGELOG.md#09824-july-3-2014)
the install directory for Chocolatey has changed from `C:\Chocolatey` to
`C:\ProgramData\Chocolatey`.

More information can be gotten from the [Chocolatey
wiki](https://github.com/chocolatey/chocolatey/wiki/DefaultChocolateyInstallReasoning).

Attributes
----------

-   `['chocolatey']['Uri']` -- The URL for downloading the powershell
    installation script (default: `https://chocolatey.org/install.ps1`).
-   `['chocolatey']['upgrade']` -- Should chocolatey automatically upgrade
    itself (default: `true`).

The "chocolatey" Resource/Provider
----------------------------------

### Actions

-   `:install`: Install a chocolatey package (default)
-   `:upgrade`: Update a chocolatey package
-   `:remove`: Uninstall a chocolatey package

### Attribute Parameters

-   `package_name`: string or package to manage
-   `package`: package to manage (default package\_name)
-   `version`: The version of the package to use.
-   `source`
-   `args`: arguments to the installation

### Example

``` ruby
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
```
