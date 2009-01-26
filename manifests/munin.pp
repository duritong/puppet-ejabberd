class ejabberd::munin {
  case $ejabberd_domains {
    '': { $ejabberd_domains = $fqdn }
  }
  munin::plugin::deploy{'ejabberd_users': 
    source => "ejabberd/munin/ejabberd_", 
    config => "env.vhosts ${$ejabberd_domains}\nuser root" 
  }
  munin::plugin{'ejabberd_connections': 
    require => Munin::Plugin::Deploy['ejabberd_users'],
    config => "env.vhosts ${$ejabberd_domains}\nuser root" 
  }
  munin::plugin{'ejabberd_registrations': 
    require => Munin::Plugin::Deploy['ejabberd_users'],
    config => "env.vhosts ${$ejabberd_domains}\nuser root" 
  }
}
