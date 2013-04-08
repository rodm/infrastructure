
class teamcity::agent (
  $installdir,
  $user,
  $jdkhome,
  $serverurl = undef,
) {

  Exec {
    path => ['/sbin', '/bin', '/usr/sbin', '/usr/bin'],
  }

  $dirs = [
    "$installdir",
    "/home/$user/teamcity/agent",
    "/home/$user/teamcity/bin",
    "/home/$user/teamcity/conf",
    "/home/$user/teamcity/conf/agent"
  ]

  file { $dirs:
    ensure => directory,
    owner => $::user,
    group => $::user,
    require => User[$user],
  }

  file { 'agent.sh':
    path    => "${installdir}/bin/agent.sh",
    ensure  => file,
    mode    => 0755,
    owner   => $user,
    group   => $user,
    source  => "puppet:///modules/teamcity/agent.sh",
  }

  file { 'buildAgent.conf':
    path    => "${installdir}/conf/${::hostname}.conf",
    ensure  => file,
    owner   => $user,
    group   => $user,
    content => template("teamcity/buildAgent.conf.erb"),
  }

  file { 'buildAgent.properties':
    path    => "${installdir}/conf/agent/${::hostname}.properties",
    ensure  => file,
    owner   => $user,
    group   => $user,
    content => template("teamcity/buildAgent.properties.erb"),
  }

  file { "buildAgent.zip":
    mode => 0644,
    owner => $user,
    group => $user,
    path => "/tmp/buildAgent.zip",
    source => "puppet:///modules/teamcity/buildAgent.zip",
  }

  exec { "install-build-agent":
    command => "unzip -q /tmp/buildAgent.zip",
    cwd => "/home/${::user}/teamcity/agent",
    user => $user,
    require => File["buildAgent.zip"]
  }

  file { "agent.sh-perms":
    path    => "${installdir}/agent/bin/agent.sh",
    mode    => 0755,
    owner   => $user,
    group   => $user,
    require => Exec["install-build-agent"]
  }
}
