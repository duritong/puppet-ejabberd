# manifests/nagios.pp

class ejabberd::nagios {
  case $jabber_nagios_domain {
    '': { $jabber_nagios_domain = $fqdn }
  }
  nagios::service{ "jabber_${fqdn}": check_command => "check_jabber!${jabber_nagios_domain}" }

  case $jabber_nagios_user {
    '': { $jabber_nagios_user = 'nagios' }
  } 

  nagios::plugin{'check_jabber_login':
    source => 'ejabberd/nagios/check_jabber_login';
  }

  @@nagios_command{
    'check_jabber_login':
      command_line => '$USER1$/check_jabber_login $ARG1$ $ARG2$',
      require => Nagios::Plugin['check_jabber_login'];
  }

  case $jabber_nagios_pwd {
    '': { info("no \$jabber_nagios_pwd supplied for ${fqdn}! Can't test jabber login") }
    default: { 
      nagios::service{ "jabber_login_${fqdn}": check_command => "check_jabber_login!${jabber_nagios_user}@${jabber_nagios_domain}!${jabber_nagios_pwd}" }
    }
  }
}
