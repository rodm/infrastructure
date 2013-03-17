
class java ( $version, $installdir = '/opt' ) {

  define install( $version, $installdir = '/opt', $user = 'root' ) {

    Exec {
      path => ['/sbin', '/bin', '/usr/sbin', '/usr/bin'],
    }

    $java_major_version = regsubst($version, '^(\d+)u(\d+)$','\1')
    $java_update_version = regsubst($version, '^(\d+)u(\d+)$','\2')

    if $::architecture == 'i386' {
      $osarch = 'i586'
    } else {
      $osarch = 'x64'
    }

    if $java_major_version == '6' {
      $filename = "jdk-${version}-linux-${osarch}.bin"
      $install_cmd = "sh /tmp/${filename} -noregister"
    } else {
      $filename = "jdk-${version}-linux-${osarch}.tar.gz"
      $install_cmd = "tar -zxf /tmp/${filename}"
    }

    file { "jdk-${version}":
      mode => 0644,
      owner => root,
      group => root,
      path => "/tmp/${filename}",
      source => "puppet:///modules/java/${filename}",
      before => Exec["install-jdk-${version}"],
    }

    exec { "install-jdk-${version}":
      command => $install_cmd,
      cwd => "${installdir}",
      creates => "${installdir}/jdk1.${java_major_version}.0_${java_update_version}",
      user => $user,
    }
  }
}
