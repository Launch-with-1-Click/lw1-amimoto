cfn = JSON.load(::File.read('/opt/aws/cloud_formation.json'))
describe_cmd = "/usr/bin/aws ec2 describe-instances --instance-id #{cfn['nfs']['server']['instance-id']} --region #{node.ec2[:placement_availability_zone].chop} "
masterserver = JSON.load(`#{describe_cmd}`)
master_ip = masterserver['Reservations'].first['Instances'].first["PrivateIpAddress"]

mount "/var/www/vhosts/#{node[:ec2][:instance_id]}" do
  action [:mount]
  device "#{master_ip}:/var/www/vhosts/#{cfn['nfs']['server']['instance-id']}"
  fstype "nfs"
  options "rw"
end

mount "/var/cache/nginx/proxy_cache" do
  action [:mount]
  device "#{master_ip}:/var/cache/nginx/proxy_cache"
  fstype "nfs"
  options "rw"
end


template '/opt/aws/nfs_client.rb' do
  source 'cfn/nfs_client.rb.erb'
end

rc_line = '/usr/bin/chef-apply /opt/aws/nfs_client.rb > /dev/null 2>&1'
file '/etc/rc.local' do
  _file = Chef::Util::FileEdit.new('/etc/rc.local')
  _file.insert_line_if_no_match('/opt/aws/nfs_client.rb', [rc_line, "\n"].join)
  content _file.send(:contents).join
  manage_symlink_source true
end.run_action(:create)

