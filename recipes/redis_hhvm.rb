package 'redis' do
  action [:install, :upgrade]
end

service 'redis' do
  action [:start, :enable]
end
