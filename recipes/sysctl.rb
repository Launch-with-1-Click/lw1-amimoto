execute 'reload sysctl' do
  action :nothing
  command 'sysctl -e -p'
  not_if { node[:virtualization][:system] == 'docker' }
end


ruby_block 'sysctl tuning' do
  block do
    file = Chef::Util::FileEdit.new('/etc/sysctl.conf')
    file.insert_line_if_no_match(/vm\.swappiness/, 'vm.swappiness=0')
    file.write_file
  end
  notifies :run, 'execute[reload sysctl]', :immediately
  not_if 'grep swappiness /etc/sysctl.conf'
end

if node[:virtualization][:system] != 'docker'
  mount_swap_file
end
