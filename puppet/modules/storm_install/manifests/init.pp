class storm_install {
  package { 'supervisor': }

  group { 'storm':
    gid    => 1010,
    ensure => 'present',
  }

  user { 'storm':
    uid        => 1010,
    gid        => 'storm',
    groups     => ['daemon','hadoop'],
    home       => '/home/storm',
    managehome => 'true',
    shell      => '/bin/bash',
    ensure     => 'present',
  }

  exec { 'download_storm':
    command   => 'wget http://public-repo-1.hortonworks.com/HDP-LABS/Projects/Storm/0.9.0.1/storm-0.9.0.1.tar.gz',
    cwd       => '/tmp',
    creates   => '/tmp/storm-0.9.0.1.tar.gz',
    path      => ['/bin', '/usr/bin', '/usr/sbin'],
    logoutput => true,
  }
  ->
  exec { 'untar_storm':
    command => 'tar xzf /tmp/storm-0.9.0.1.tar.gz',
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
  file { '/etc/storm/storm.yaml':
    ensure => 'symlink',
    target => '/usr/share/storm/conf/storm.yaml',
  }
  ->
  file { '/var/log/storm':
    ensure => 'directory',
    owner  => 'storm',
    group  => 'storm',
  }
}
