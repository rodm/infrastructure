
class ssh {

  package { 'openssh-server':
    ensure => installed,
    before => File['/etc/ssh/sshd_config'],
  }

  file { '/etc/ssh/sshd_config':
    ensure => file,
    owner => 'root',
    group => 'root',
    mode => '0600',
    source => 'puppet:///modules/ssh/sshd_config',
  }

  service { 'ssh':
    ensure => running,
    enable => true,
    subscribe => File['/etc/ssh/sshd_config'],
  }
}