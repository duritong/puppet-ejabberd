# manages the basic stuff for the service
class ejabberd::base {
  package { 'ejabberd':
    ensure => installed,
  } -> file_line { 'set_erlang_node_name':
    line   => "ERLANG_NODE=ejabberd@${facts['networking']['fqdn']}",
    path   => '/opt/ejabberd/conf/ejabberdctl.cfg',
    match  => '^(#)?ERLANG_NODE=',
    notify => Service['ejabberd'],
  } -> file { '/opt/ejabberd/conf/ejabberd.yml':
    owner  => 'root',
    group  => 'ejabberd',
    mode   => '0640',
    notify => Service['ejabberd'],
  } -> exec { 'copy-ejabberd-service-unit':
    command => "cp /opt/ejabberd-$(rpm -q --queryformat='%{VERSION}' ejabberd)/bin/ejabberd.service /etc/systemd/system/ejabberd.service",
    unless  => "diff -Naur /opt/ejabberd-$(rpm -q --queryformat='%{VERSION}' ejabberd)/bin/ejabberd.service /etc/systemd/system/ejabberd.service",
  } ~> service { 'ejabberd':
    ensure => running,
    enable => true,
  }

  if $ejabberd::config_content {
    File['/opt/ejabberd/conf/ejabberd.yml'] {
      content => $ejabberd::config_content,
    }
  } else {
    File['/opt/ejabberd/conf/ejabberd.yml'] {
      source => ["puppet:///modules/site_ejabberd/${facts['networking']['fqdn']}/ejabberd.yml",
        'puppet:///modules/site_ejabberd/ejabberd.yml',
      'puppet:///modules/ejabberd/ejabberd.yml',]
    }
  }
}
