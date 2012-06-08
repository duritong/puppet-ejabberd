# manifests/init.pp - manage ejabberd stuff
# Copyright (C) 2007 admin@immerda.ch
# GPLv3

class ejabberd(
  $domains = $::fqdn,
  $nagios_domain = hiera('ejabberd_nagios_domain', $::fqdn),
  $nagios_user = hiera('ejabberd_nagios_user', 'nagios'),
  $nagios_pwd = hiera('ejabberd_nagios_pwd','')
) {
  case $::operatingsystem {
    default: { include ejabberd::base }
  }
  if hiera('use_nagios',false) {
    include ejabberd::nagios
  }

  if hiera('use_munin',false) {
    include ejabberd::munin
  }

  if hiera('use_shorewall',false) {
    include shorewall::rules::jabberserver
  }
}
