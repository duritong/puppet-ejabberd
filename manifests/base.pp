class ejabberd::base {
    package{'ejabberd':
        ensure => installed,
    }

    file{'/etc/ejabberd/ejabberd.cfg':
      source => [ "puppet://$server/files/ejabberd/${fqdn}/ejabberd.cfg",
                  "puppet://$server/files/ejabberd/ejabberd.cfg",
                  "puppet://$server/modules/ejabberd/ejabberd.cfg" ],
      require => Package['ejabberd'],
      notify => Service['ejabberd'],
      owner => ejabberd, group => ejabberd, mode => 0640;
    }

    service{ejabberd:
        ensure => running,
        enable => true,
        hasstatus => true, #fixme!
        require => Package[ejabberd],
    }
}
