node[:goofys][:packages].map do |pkg|
  package pkg do
    action [:install, :upgrade]
    notifies :run, 'bash[update-motd]', :delayed
  end
end

directory "/usr/local/bin" do
  mode 00755
  recursive true
  action :create
end

remote_file "/usr/local/bin/goofys" do
  source node[:goofys][:source_url]
  owner 'root'
  group 'root'
  mode 00755
  action :create
end

if node[:goofys][:mount]
  directory node[:goofys][:config][:mount_point] do
    owner node[:nginx][:config][:user]
    group node[:nginx][:config][:group]
    mode 00755
    notifies :run, "bash[goofys-mount]", :delayed
  end

  bash "goofys-mount" do
    user "root"
    cwd "/tmp"
    code <<-EOH
      /usr/local/bin/goofys -o allow_other \
        --uid "$(id -u #{node[:nginx][:config][:user]})" --gid "$(id -g #{node[:nginx][:config][:group]})" \
        --profile #{node[:goofys][:config][:profile]} \
        --region #{node[:goofys][:config][:reagion]} \
        #{node[:goofys][:config][:s3_bucket]} #{node[:goofys][:config][:mount_point]}
    EOH
  end
end

# update-motd
include_recipe 'amimoto::update-motd'
