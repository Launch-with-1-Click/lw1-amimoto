default[:wpcli][:dir] = '/usr/share/wp-cli'
default[:wpcli][:version] = '@stable'
default[:wpcli][:link] = '/usr/bin/wp'
default[:wpcli][:installer] = 'https://raw.github.com/wp-cli/wp-cli.github.com/master/installer.sh'

default[:sysconfig][:lang] = 'en_US.UTF-8'
default[:sysconfig][:sysfont] = 'latarcyrheb-sun16'
case node[:ec2][:placement_availability_zone].chop
when 'ap-northeast-1'
  default[:sysconfig][:lang] = 'ja_JP.UTF-8'
end
