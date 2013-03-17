
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
    "/home/$user/teamcity/conf",
    "/home/$user/teamcity/conf/agent"
  ]

  file { $dirs:
    ensure => directory,
    owner => $::user,
    group => $::user,
    require => User[$user],
  }

  file { 'buildAgent.conf':
    path    => "${installdir}/conf/${::hostname}.conf",
    ensure  => file,
    content => template("teamcity/buildAgent.conf.erb"),
  }

  file { 'buildAgent.properties':
    path    => "${installdir}/conf/agent/${::hostname}.properties",
    ensure  => file,
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
    cwd => "/home/builder/teamcity/agent",
    user => $user,
  }
}
