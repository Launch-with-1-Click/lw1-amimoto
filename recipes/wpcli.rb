# install wp-cli

git node[:wpcli][:dir]  do
  repository "git://github.com/wp-cli/builds.git"
#  revision 'master'
end

bin = ::File.join(node[:wpcli][:dir], 'phar', 'wp-cli.phar')
file bin do
  mode '0755'
  action :create
  # only_if { ::File.exists?(bin) }
end

link node[:wpcli][:link] do
  to bin
end

