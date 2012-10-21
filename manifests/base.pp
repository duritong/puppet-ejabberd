# manages the basic stuff for the service
class ejabberd::base {
  package{'ejabberd':
    ensure => installed,
  }

  file{'/etc/ejabberd/ejabberd.cfg':
    require => Package['ejabberd'],
    notify  => Service['ejabberd'],
    owner   => 'root',
    group   => 'ejabberd',
    mode    => '0640';
  }

  if $ejabberd::config_content {
    File['/etc/ejabberd/ejabberd.cfg']{
      content => $ejabberd::config_content
    }
  } else {
    File['/etc/ejabberd/ejabberd.cfg']{
      source => [ "puppet:///modules/site_ejabberd/${::fqdn}/ejabberd.cfg",
                  'puppet:///modules/site_ejabberd/ejabberd.cfg',
                  'puppet:///modules/ejabberd/ejabberd.cfg' ]
    }
  }

  service{'ejabberd':
    ensure    => running,
    enable    => true,
    hasstatus => true,
    require   => Package['ejabberd'],
  }
}
