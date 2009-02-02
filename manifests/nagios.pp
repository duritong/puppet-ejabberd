# manifests/nagios.pp

class ejabberd::nagios {
    case $jabber_nagios_domain {
        '': { $jabber_nagios_domain = $fqdn }
    }
    nagios::service{ "jabber_${fqdn}": check_command => "check_jabber!${jabber_nagios_domain}" }

    case $jabber_nagios_user {
        '': { $jabber_nagios_user = 'nagios' }
    } 

    case $jabber_nagios_pwd {
        '': { info("no \$jabber_nagios_pwd supplied for ${fqdn}! Can't test jabber login") }
        default: { 
            nagios::service{ "jabber_${fqdn}": check_command => "check_jabber_login!${jabber_nagios_user}@${jabber_nagios_domain}!${jabber_nagios_pwd}" }
        }
    }
}
