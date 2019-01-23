# install jq
%w{ jq }.each do | pkg |
  package pkg do
    action [:install, :upgrade]
  end
end

# install wp-cli
git node[:wpcli][:dir]  do
  repository node[:wpcli][:repository]
end

bin = ::File.join(node[:wpcli][:dir], 'phar', 'wp-cli.phar')
file bin do
  mode '0755'
  action :create
  only_if { ::File.exists?(bin) }
  notifies :run, 'bash[update-motd]', :delayed
end

link node[:wpcli][:link] do
  to bin
end

wp_setup = "/usr/local/bin/wp-setup"
template wp_setup do
  variables(
    :default_server_name => node[:ec2][:instance_id]
  )
  source "wp-setup.erb"
end
file wp_setup do
  mode '0755'
  action :create
  only_if { ::File.exists?(bin) }
end

wp_setup_json = "/usr/local/bin/wp-setup-json"
template wp_setup_json do
  variables(
    :default_server_name => node[:ec2][:instance_id]
  )
  source "wp-setup-json.erb"
end
file wp_setup_json do
  mode '0755'
  action :create
  only_if { ::File.exists?(bin) }
end
