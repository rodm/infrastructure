
$user = 'builder'
$pkgs = [ 'unzip', 'xvfb', 'libxtst6', 'libxi6', 'libxrender1', 'libfontconfig1', 'subversion', 'cvs' ]
$ntpserver = 'time.euro.apple.com'

exec { "apt-get update":
  command => '/usr/bin/apt-get update',
}

user { $user:
  ensure     => present,
  shell      => '/bin/bash',
  home       => "/home/$::user",
  managehome => true,
}

file { 'tools dir':
  ensure => directory,
  path => "/home/$::user/tools",
  owner => $::user,
  group => $::user,
  require => User['builder'],
}

package { $pkgs:
  ensure  => installed,
  require => Exec['apt-get update']
}

class { 'ntp':
  servers => [ "$::ntpserver" ],
}

class { 'ssh':
}

class { 'teamcity::agent':
  installdir => "/home/$::user/teamcity",
  user => $user,
  jdkhome => "/home/$::user/teamcity/jdk1.6.0_41",
  serverurl => 'http//teamcity:8111/teamcity',
}

java::install { '6u41':
  version => '6u41',
  installdir => "/home/${user}/tools",
  user => $user,
}

java::install { '7u10':
  version => '7u10',
  installdir => "/home/${user}/tools",
  user => $user,
}

java::install { '7u15':
  version => '7u15',
  installdir => "/home/${user}/tools",
  user => $user,
}
