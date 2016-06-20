node[:goofys][:packages].map do |pkg|
  package pkg do
    action [:install, :upgrade]
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
