execute 'reload sysctl' do
  action :nothing
  command 'sysctl -e -p'
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

mount_swap_file
