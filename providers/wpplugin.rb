action :install do
  plugins_path = "#{::File.join(new_resource.install_path,'/wp-content/plugins/')}"
  install_path = "#{::File.join(new_resource.install_path,'/wp-content/plugins/',new_resource.plugin_name)}"
  release_file = "#{new_resource.plugin_name}.zip"
  work_file    = "#{::File.join('/tmp/.cache/wpplugins/',release_file)}"
  release_url  = "http://downloads.wordpress.org/plugin/#{new_resource.plugin_name}.zip"

  directory '/tmp/.cache/wpplugins/' do
    recursive true
    owner node[:nginx][:config][:user]
    group node[:nginx][:config][:group]
    mode 00775
    action :create
  end

  directory install_path do
    recursive true
    owner node[:nginx][:config][:user]
    group node[:nginx][:config][:group]
    mode 00775
    action :create
    notifies :run, 'bash[wp-plugin-unpack]', :immediately
  end

  remote_file work_file do
    source release_url
    action :create
    notifies :run, 'bash[wp-plugin-unpack]', :immediately
  end

  # unpack WordPress plugin
  bash "wp-plugin-unpack" do
    action :nothing
    user "root"
    umask '0002'
    cwd "/tmp"
    code <<-EOH
      /usr/bin/unzip #{work_file} -d #{plugins_path}
      if [ "wp-redis" = "#{new_resource.plugin_name}" ]; then
        /bin/cp -p #{::File.join(install_path,'object-cache.php')} #{::File.join(new_resource.install_path,'/wp-content')}
        chown -R #{node[:nginx][:config][:user]}:#{node[:nginx][:config][:group]} #{::File.join(new_resource.install_path,'/wp-content/object-cache.php')}
      fi
      chown -R #{node[:nginx][:config][:user]}:#{node[:nginx][:config][:group]} #{install_path}
    EOH
  end
end
