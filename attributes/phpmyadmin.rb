require 'securerandom'

default[:phpmyadmin][:version] = "4.6.3"
default[:phpmyadmin][:blowfish_secret] = SecureRandom.hex(16)
default[:phpmyadmin][:servers] = [
  {
    "auth_type" => "cookie",
    "host" => "localhost",
    "connect_type" => "tcp",
    "compress" => "false",
    "allow_no_password" => "false"
  }
]
