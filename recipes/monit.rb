if %w(redhat).include?(node[:platform])
  yum_package 'monit' do
    action [:install, :upgrade]
    options '--enablerepo=rpmforge'
    flush_cache [:before]
  end
else
  package 'monit' do
    action [:install, :upgrade]
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

node[:monit][:settings][:processes].each do |monit|
  template ::File.join(node[:monit][:config_dir], monit[:name]) do
    source node[:monit][:source][monit[:name]]
    variables monit
    notifies :reload, 'service[monit]'
  end
end
