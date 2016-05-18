require 'securerandom'

default[:wordpress][:servername] =  node[:ec2][:instance_id]
default[:wordpress][:version] = '4.5.2'
default[:wordpress][:wp_multisite] = node[:nginx][:config][:wp_multisite]
default[:wordpress][:mobile_detect_enable] = node[:nginx][:config][:mobile_detect_enable]
default[:wordpress][:phpmyadmin_enable] = node[:nginx][:config][:phpmyadmin_enable]
default[:wordpress][:table_prefix] = 'wp_'

default[:wordpress][:db][:db_name] = node[:wordpress][:servername]
default[:wordpress][:db][:user_name] = node[:wordpress][:servername]
default[:wordpress][:db][:password] = SecureRandom.hex(32)
default[:wordpress][:db][:host] = 'localhost'
default[:wordpress][:db][:rootpass] = ''

default[:wordpress][:salt][:auth_key] = SecureRandom.hex(32)
default[:wordpress][:salt][:secure_auth_key] = SecureRandom.hex(32)
default[:wordpress][:salt][:logged_in_key] = SecureRandom.hex(32)
default[:wordpress][:salt][:nonce_key] = SecureRandom.hex(32)
default[:wordpress][:salt][:auth_salt] = SecureRandom.hex(32)
default[:wordpress][:salt][:secure_auth_salt] = SecureRandom.hex(32)
default[:wordpress][:salt][:logged_in_salt] = SecureRandom.hex(32)
default[:wordpress][:salt][:nonce_salt] = SecureRandom.hex(32)

default[:wordpress][:plugins] = %w{ nginx-champuru nephila-clavata c3-cloudfront-clear-cache debug-bar debug-bar-extender debug-bar-console login-lockdown rublon nginx-mobile-theme flamingo contact-form-7 simple-ga-ranking }