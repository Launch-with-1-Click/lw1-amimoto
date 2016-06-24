service 'iptables' do
  action [:stop, :disable]
  not_if { node[:virtualization][:system] == 'docker' }
end
