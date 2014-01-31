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
}
