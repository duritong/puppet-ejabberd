# manifests/init.pp - manage ejabberd stuff
# Copyright (C) 2007 admin@immerda.ch
# GPLv3

class ejabberd {
  case $operatingsystem {
    default: { include ejabberd::base }
  }
  if $use_nagios {
    include ejabberd::nagios
  }

  if $use_munin {
    include ejabberd::munin
  }

  if $use_shorewall {
    include shorewall::rules::jabberserver
  }
}
