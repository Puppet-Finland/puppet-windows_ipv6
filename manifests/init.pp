# Manage ipv6 settings in Windows
#
# == Parameters:
#
# $disabled_components_value:: value for the "DisabledComponents".
#                              Defaults to '0x20' to prefer IPv4 over IPv6 by changing entries in the prefix policy table
#
# Valid values are:
# 0 to re-enable all IPv6 components (Windows default setting).
# 0xff to disable all IPv6 components except the IPv6 loopback interface.
# This value also configures Windows to prefer using IPv4 over IPv6 by changing entries in the prefix policy# table.
# For more information, see Source and destination address selection.
# 0x20 to prefer IPv4 over IPv6 by changing entries in the prefix policy table.
# 0x10 to disable IPv6 on all nontunnel interfaces (both LAN and Point-to-Point Protocol [PPP] interfaces).
# 0x01 to disable IPv6 on all tunnel interfaces. These include Intra-Site Automatic Tunnel Addressing Protocol (ISATAP), 6to4, and Teredo.
# 0x11 to disable all IPv6 interfaces except for the IPv6 loopback interface.
# https://support.microsoft.com/en-us/kb/929852
class windows_ipv6
(
  String $disabled_components_value = '0x20',
)
{

  unless $disabled_components_value in [ '0', '0xff', '0x20', '0x10', '0x01', '0x11' ] {
    fail("Invalid value ${disabled_components_value} for the DisabledComponents key")
  }

  $reg_basepath = 'HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\Tcpip6\Parameters'

  dsc_registry { 'Manage IPv6 settings':
    dsc_ensure    => 'Present',
    dsc_key       => $reg_basepath,
    dsc_valuename => 'DisabledComponents',
    dsc_valuedata => $disabled_components_value,
  }

  reboot { 'After IPv6 settings':
    subscribe => Dsc_registry['Manage IPv6 settings'],
  }
}
