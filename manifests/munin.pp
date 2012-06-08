class ejabberd::munin {
  munin::plugin::deploy{'ejabberd_':
    source => "ejabberd/munin/ejabberd_",
    ensure => absent,
  }
  $domains = join($ejabberd::domains, ' ')
  munin::plugin{['ejabberd_users','ejabberd_connections','ejabberd_registrations']:
    require => Munin::Plugin::Deploy['ejabberd_'],
    ensure => 'ejabberd_',
    config => "env.vhosts ${domains}\ntimeout 20\nuser root\ngroup root"
  }
}
