# install wp-cli

git node[:wpcli][:dir]  do
  repository "git://github.com/wp-cli/builds.git"
#  revision 'master'
end

bin = ::File.join(node[:wpcli][:dir], 'phar', 'wp-cli.phar')
file bin do
  mode '0755'
  action :create
  only_if { ::File.exists?(bin) }
end

link node[:wpcli][:link] do
  to bin
end

wp_setup = "/usr/local/bin/wp-setup"
template wp_setup do
  source "wp-setup.erb"
end
file wp_setup do
  mode '0755'
  action :create
  only_if { ::File.exists?(bin) }
end

wp_plugin_install = "/usr/local/bin/wp-plugin-install"
template wp_plugin_install do
  source "wp-plugin-install.erb"
end
file wp_plugin_install do
  mode '0755'
  action :create
  only_if { ::File.exists?(bin) }
end
