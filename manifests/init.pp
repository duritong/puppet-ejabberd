# manifests/init.pp - manage ejabberd stuff
# Copyright (C) 2007 admin@immerda.ch
# GPLv3

# Manage an ejabberd server
class ejabberd(
  $domains          = $::fqdn,
  $config_content   = false,
  $nagios_domain    = $::fqdn,
  $nagios_user      = 'nagios',
  $nagios_pwd       = '',
  $manage_nagios    = false,
  $manage_munin     = false,
  $manage_shorewall = false
) {
  case $::operatingsystem {
    default: { include ejabberd::base }
  }
  if $manage_nagios {
    include ejabberd::nagios
  }

  if $manage_munin {
    include ejabberd::munin
  }

  if $manage_shorewall {
    include shorewall::rules::jabberserver
  }
}
