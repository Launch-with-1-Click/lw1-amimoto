require 'securerandom'

default[:wordpress][:servername] =  node[:ec2][:instance_id]
default[:wordpress][:version] = '4.5.2'
default[:wordpress][:wp_multisite] = node[:nginx][:config][:wp_multisite]
default[:wordpress][:mobile_detect_enable] = node[:nginx][:config][:mobile_detect_enable]
default[:wordpress][:phpmyadmin_enable] = node[:nginx][:config][:phpmyadmin_enable]
default[:wordpress][:table_prefix] = 'wp_'
default[:wordpress][:woocommerce] = false
default[:wordpress][:jinkei_cf] = false

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

default[:wordpress][:plugins] = %w{
  nginx-champuru
  nginx-mobile-theme
  nephila-clavata
  c3-cloudfront-clear-cache
  debug-bar
  debug-bar-extender
  debug-bar-console
  login-lockdown
  rublon
  flamingo
  contact-form-7
  simple-ga-ranking
  }
default[:wordpress][:mu_plugins] = %w{
  mu-plugins.php
  }
default[:wordpress][:themes] = %w{}

if node[:redis][:enabled]
  default[:wordpress][:plugins].push('wp-redis')
end

if node[:wordpress][:woocommerce]
  default[:wordpress][:plugins].push('woocommerce')
  default[:wordpress][:mu_plugins].push('require-plugins-for-woo.php')
  default[:wordpress][:themes].push('storefront')
end

if node[:wordpress][:jinkei_cf]
  default[:wordpress][:mu_plugins].push('amimoto-utilities.php')
  default[:wordpress][:mu_plugins].push('cf-hostfix.php')
  default[:wordpress][:mu_plugins].push('cf-previewfix.php')
  default[:wordpress][:mu_plugins].push('init-plugins.php')
end
