install_path = "/usr/share/phpMyAdmin"
release      = "phpMyAdmin-#{node[:phpmyadmin][:version]}-all-languages"
release_file = "#{release}.zip"
work_file    = "#{::File.join('/usr/share/',release_file)}"
release_url  = "http://repos.amimoto-ami.com/phpmyadmin/#{release_file}"

directory '/usr/share/' do
  recursive true
  action :create
end

# unpack phpMyAdmin
bash "phpmyadmin-unpack" do
  action :nothing
  user "root"
  cwd "/tmp"
  code <<-EOH
    [ ! -f #{install_path} ] && \
      rm -f #{install_path}
    [ ! -d /usr/share/#{release} ] && \
      /usr/bin/unzip #{work_file} -d /usr/share
  EOH
  notifies :create, "link[#{install_path}]"
end

directory install_path do
  action :delete
  not_if { File.symlink?(install_path) }
  notifies :create, "link[#{install_path}]"
end

link install_path do
   action :nothing
   link_type :symbolic
   to "/usr/share/#{release}"
   notifies :create, "template[#{install_path}/config.inc.php]"
end

remote_file work_file do
  source release_url
  action :create
  notifies :run, 'bash[phpmyadmin-unpack]', :immediately
end

template "#{install_path}/config.inc.php" do
  action :nothing
  variables node[:phpmyadmin]
  source "phpmyadmin/config.inc.php.erb"
  notifies :create, "directory[#{install_path}/tmp]"
end

directory "#{install_path}/tmp" do
  action :nothing
  owner node[:nginx][:config][:user]
  group node[:nginx][:config][:group]
end
