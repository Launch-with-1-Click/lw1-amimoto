# install wp-cli
directory node[:wpcli][:dir] do
  recursive true
end

remote_file "#{node[:wpcli][:dir]}/installer.sh" do
  source node[:wpcli][:installer]
  mode 0755
  action :create_if_missing
end

bin = ::File.join(node[:wpcli][:dir], 'bin', 'wp')

bash 'install wp-cli' do
  code 'sh ./installer.sh'
  cwd node[:wpcli][:dir]
  environment 'INSTALL_DIR' => node[:wpcli][:dir],
              'VERSION' => node[:wpcli][:version]
  creates bin
end

link node[:wpcli][:link] do
  to bin
end

