# manifests/nagios.pp

class ejabberd::nagios {
  nagios::service{ "jabber_${::fqdn}": check_command => "check_jabber!${ejabberd::nagios_domain}" }
  @@nagios_command{
    'check_jabber_ssl':
      command_line => '$USER1$/check_jabber -S -p 5223 -H $ARG1$',
  }
  nagios::service{ "jabber_ssl_${::fqdn}": check_command => "check_jabber_ssl!${ejabberd::nagios_domain}" }

  @@nagios_command{
    'check_jabber_cert':
      command_line => '$USER1$/check_jabber -S -D 10 -p 5223 -H $ARG1$',
  }
  nagios::service{ "jabber_cert_${::fqdn}": check_command => "check_jabber_cert!${ejabberd::nagios_domain}" }

  @@nagios_command{
    'check_jabber_login':
      command_line => '$USER1$/check_jabber_login $ARG1$ $ARG2$',
      require => Nagios::Plugin['check_jabber_login'];
  }

  case $ejabberd::nagios_pwd {
    '': { info("no \$ejabberd::nagios_pwd supplied for ${::fqdn}! Can't test jabber login") }
    default: {
      nagios::service{ "jabber_login_${::fqdn}": check_command => "check_jabber_login!${ejabberd::nagios_user}@${ejabberd::nagios_domain}!${ejabberd::nagios_pwd}" }
    }
  }
}
