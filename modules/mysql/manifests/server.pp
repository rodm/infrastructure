
class mysql::server {
  package { "mysql-server":
    ensure => installed
  }

  service { "mysql":
    enable => true,
    ensure => running,
    require => Package["mysql-server"],
  }

  file { "/etc/mysql/my.cnf":
    owner => "mysql",
    group => "mysql",
    source => "puppet:///mysql/my.cnf",
    notify => Service["mysql"],
    require => Package["mysql-server"],
  }

  exec { "set-mysql-password":
    unless => "/usr/bin/mysqladmin -u root -p ${mysql_password} status",
    command => "/usr/bin/mysqladmin -u root -p password ${mysql_password}",
    require => Service["mysql"],
  }

  define db( $user, $password ) {
    include mysql::server

    exec { "create-${name}-db":
      unless => "/usr/bin/mysql -u${user} -p${password} ${name}",
      command => "/usr/bin/mysql -uroot -p${mysql_password} -e \"create database ${name}; grant all on ${name}.* to ${user}@'%' identified by '${password}'; flush privileges;\"",
      require => Service["mysql"],
    }
  }
}

