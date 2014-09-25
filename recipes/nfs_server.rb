nginx_uid = `id -u nginx`.chomp
nginx_gid = `id -g nginx`.chomp

file '/etc/exports' do
  action :create
  content [
    "/var/www/vhosts/#{node[:ec2][:instance_id]} *(rw,async,no_acl,root_squash,all_squash,anonuid=#{nginx_uid},anongid=#{nginx_gid})",
    "/var/cache/nginx/proxy_cache *(rw,async,no_acl,root_squash,all_squash,anonuid=#{nginx_uid},anongid=#{nginx_gid})"
    ].join("\n")
end

%w(rpcbind nfslock nfs).each do |svc|
  service svc do
    action [:enable, :start]
    subscribes :restart, 'file[/etc/exports]'
  end
end

