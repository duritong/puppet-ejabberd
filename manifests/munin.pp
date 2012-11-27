# install munin plugin and helpers
class ejabberd::munin {
  munin::plugin::deploy{'ejabberd_':
    ensure => absent,
    source => 'ejabberd/munin/ejabberd_';
  }
  $domains = join($ejabberd::domains, ' ')
  munin::plugin{['ejabberd_users','ejabberd_connections','ejabberd_registrations']:
    ensure  => 'ejabberd_',
    require => [ Munin::Plugin::Deploy['ejabberd_'] ],
    config  => "env.vhosts ${domains}\ntimeout 30\nuser root\ngroup root";
  }
  file{
    '/etc/cron.daily/ejabberd_registrations':
      source  => 'puppet:///modules/ejabberd/munin/ejabberd_registrations.cron',
      require => Munin::Plugin['ejabberd_registrations'],
      owner   => root,
      group   => 0,
      mode    => '0700';
  }
}
