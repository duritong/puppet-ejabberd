# manages the basic stuff for the service
class ejabberd::base {
  if $facts['osfamily'] == 'RedHat' and $facts['operatingsystemmajrelease'] == '6' {
    $config_file = '/etc/ejabberd/ejabberd.cfg'
    if !$ejabberd::config_content {
      $sources = [ "puppet:///modules/site_ejabberd/${::fqdn}/ejabberd.cfg",
                  'puppet:///modules/site_ejabberd/ejabberd.cfg',
                  'puppet:///modules/ejabberd/ejabberd.cfg', ]
    }
  } else {
    $config_file = '/opt/ejabberd/conf/ejabberd.yml'
    if !$ejabberd::config_content {
      $sources = [ "puppet:///modules/site_ejabberd/${::fqdn}/ejabberd.yml",
                  'puppet:///modules/site_ejabberd/ejabberd.yml',
                  'puppet:///modules/ejabberd/ejabberd.yml', ]
    }
  }

  package{'ejabberd':
    ensure => installed,
  } -> file{$config_file:
    owner => 'root',
    group => 'ejabberd',
    mode  => '0640';
  } ~> service{'ejabberd':
    ensure => running,
    enable => true,
  }

  if $ejabberd::config_content {
    File[$config_file]{
      content => $ejabberd::config_content,
    }
  } else {
    File[$config_file]{
      source => $sources,
    }
  }
}
