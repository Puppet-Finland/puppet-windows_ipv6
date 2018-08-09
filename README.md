# windows_ipv6

A Puppet module for configuring ipv6 settings in Windows.

# Usage

Typical usage:

    include '::windows_ipv6'

This will "Prefer ipv4 to ipv6"

See $disabled_components_value in init.pp for possible values to pass to the
class. 


