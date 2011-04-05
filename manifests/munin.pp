class ejabberd::munin {
  case $ejabberd_domains {
    '': { $ejabberd_domains = $fqdn }
  }
  munin::plugin::deploy{'ejabberd_': 
    source => "ejabberd/munin/ejabberd_", 
    ensure => absent,
  }
  munin::plugin{['ejabberd_users','ejabberd_connections','ejabberd_registrations']:
    require => Munin::Plugin::Deploy['ejabberd_'],
    ensure => 'ejabberd_',
    config => "env.vhosts ${ejabberd_domains}\ntimeout 20\nuser root\ngroup root"
  }
}
