# manifests/init.pp - manage ejabberd stuff
# Copyright (C) 2007 admin@immerda.ch
# GPLv3

class ejabberd {
    case $operatingsystem {
        default: { include ejabberd::base }
    }
}

class ejabberd::base {
    package{'ejabberd':
        ensure => installed,
    }

    file{'/etc/ejabberd/ejabberd.cfg':
      source => [ "puppet://$server/files/ejabberd/${fqdn}/ejabberd.cfg",
                  "puppet://$server/files/ejabberd/ejabberd.cfg",
                  "puppet://$server/ejabberd/ejabberd.cfg" ],
      require => Package['ejabberd'],
      notify => Service['ejabberd'],
      owner => root, group => 0, mode => 0644;
    }

    service{ejabberd:
        ensure => running,
        enable => true,
        hasstatus => true, #fixme!
        require => Package[ejabberd],
    }

}
