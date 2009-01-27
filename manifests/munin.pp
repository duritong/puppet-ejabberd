class ejabberd::munin {
  case $ejabberd_domains {
    '': { $ejabberd_domains = $fqdn }
  }
  munin::plugin::deploy{'ejabberd_': 
    source => "ejabberd/munin/ejabberd_", 
    ensure => absent,
  }
  munin::plugin{'ejabberd_users': 
    require => Munin::Plugin::Deploy['ejabberd_'],
    ensure => 'ejabberd_',
    config => "env.vhosts ${ejabberd_domains}\ntimeout 20\nuser root" 
  }
  munin::plugin{'ejabberd_connections': 
    require => Munin::Plugin::Deploy['ejabberd_'],
    ensure => 'ejabberd_',
    config => "env.vhosts ${ejabberd_domains}\nuser root" 
  }
  munin::plugin{'ejabberd_registrations': 
    require => Munin::Plugin::Deploy['ejabberd_'],
    ensure => 'ejabberd_',
    config => "env.vhosts ${ejabberd_domains}\nuser root" 
  }
}
