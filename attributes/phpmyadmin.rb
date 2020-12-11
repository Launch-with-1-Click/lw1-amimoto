require 'securerandom'

default[:phpmyadmin][:version] = "5.0.4"
if node[:phpfpm][:version] < '71'
  default[:phpmyadmin][:version] = "4.9.5"
end
default[:phpmyadmin][:blowfish_secret] = SecureRandom.hex(16)
default[:phpmyadmin][:servers] = [
  {
    "auth_type" => "cookie",
    "host" => "localhost",
    "connect_type" => "tcp",
    "compress" => "false",
    "allow_no_password" => "false",
    "hide_db" => ''
  }
]
