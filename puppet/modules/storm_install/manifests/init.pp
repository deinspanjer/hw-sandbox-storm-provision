class storm_install {
  package { 'supervisor': }
  ->
  group { 'storm':
    gid    => 1010,
    ensure => 'present',
  }
  ->
  user { 'storm':
    uid        => 1010,
    gid        => 'storm',
    groups     => ['daemon','hadoop'],
    home       => '/home/storm',
    managehome => 'true',
    shell      => '/bin/bash',
    ensure     => 'present',
  }
  ->
  exec { 'download_storm':
    command   => 'wget http://public-repo-1.hortonworks.com/HDP-LABS/Projects/Storm/0.9.0.1/storm-0.9.0.1.tar.gz',
    cwd       => '/tmp',
    creates   => '/tmp/storm-0.9.0.1.tar.gz',
    path      => ['/bin', '/usr/bin', '/usr/sbin'],
    logoutput => true,
  }
  ->
  exec { 'untar_storm':
    command => 'tar --owner=storm --group=storm -xzf /tmp/storm-0.9.0.1.tar.gz',
    cwd     => '/usr/share',
    creates => '/usr/share/storm-0.9.0.1',
    path    => ['/bin', '/usr/bin', '/usr/sbin'],
  }
  ->
  file { '/usr/share/storm-0.9.0.1':
    ensure  => 'directory',
    recurse => 'true',
    owner   => 'storm',
    group   => 'storm',
  }
  ->
  file { '/usr/share/storm':
    ensure => 'symlink',
    target => '/usr/share/storm-0.9.0.1',
  }
  ->
  file { '/etc/storm':
    ensure => 'directory',
    owner  => 'storm',
    group  => 'storm',
  }
  ->
  file { '/etc/storm/dist':
    ensure => 'symlink',
    target => '/usr/share/storm/conf',
  }
  ->
  file { '/etc/storm/storm.yaml':
    ensure => 'file',
    source => 'puppet:///modules/storm_install/storm.yaml',
    owner  => 'storm',
    group  => 'storm',
  }
  ->
  file { '/var/log/storm':
    ensure => 'directory',
    owner  => 'storm',
    group  => 'storm',
  }
  ->
  replace { 'logback_config':
    file        => '/usr/share/storm-0.9.0.1/logback/cluster.xml',
    pattern     => '\${storm\.home}/logs',
    replacement => '/var/log/storm'
  }
  ->
  file { '/etc/supervisord.conf.dist':
    ensure  => 'file',
    replace => false,
    source  => '/etc/supervisord.conf',
    require => Package['supervisor'],
  }
  ->
  concat { '/etc/supervisord.conf':
    ensure => 'present',
  }
  concat::fragment { 'supervisord_dist':
    target => '/etc/supervisord.conf',
    source => '/etc/supervisord.conf.dist',
  }
  concat::fragment { 'supervisord_storm':
    target => '/etc/supervisord.conf',
    source => 'puppet:///modules/storm_install/supervisord.conf',
  }
  ->
  service { 'supervisord':
    ensure     => 'running',
    enable     => true,
    hasrestart => true,
    hasstatus  => true,
  }
}
