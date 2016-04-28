default[:wordpress][:servername] =  node[:ec2][:instance_id]
default[:wordpress][:version] = '4.5.1'
default[:wordpress][:wp_multisite] = false
default[:wordpress][:mobile_detect_enable] = false
default[:wordpress][:phpmyadmin_enable] = false
default[:wordpress][:table_prefix] = 'wp_'
