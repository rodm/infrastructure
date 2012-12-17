
exec { "/usr/bin/apt-get update": }

$mysql_password = "admin"

mysql::server::db { "testdb":
  user => "testuser",
  password => "testpass",
}

