if %w(redhat).include?(node[:platform])
  yum_package 'monit' do
    action [:install, :upgrade]
    options '--enablerepo=rpmforge'
    flush_cache [:before]
    notifies :run, 'bash[update-motd]', :delayed
  end
else
  package 'monit' do
    action [:install, :upgrade]
    notifies :run, 'bash[update-motd]', :delayed
  end
end

service 'monit' do
  action [:enable, :start]
  reload_command 'monit reload'
end

template node[:monit][:config_file] do
  source 'monit/monit.conf.erb'
  variables node[:monit][:config]
  notifies :restart, 'service[monit]'
  mode '0600'
end

template "/etc/logrotate.d/monit" do
  source "logrotat.d/monit.erb"
end

node[:monit][:settings][:processes].each do |monit|
  if node[:monit][:monitor][monit[:name]]
    template ::File.join(node[:monit][:config_dir], monit[:name]) do
      source node[:monit][:source][monit[:name]]
      variables monit
      notifies :reload, 'service[monit]'
    end
  else
    file ::File.join(node[:monit][:config_dir], monit[:name]) do
      action :delete
      notifies :reload, 'service[monit]'
    end
  end
end
