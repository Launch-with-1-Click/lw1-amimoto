cfn = JSON.load(::File.read('/opt/aws/cloud_formation.json'))

%w(portmap nfs-utils nfs-utils-lib).each do |pkg|
  package pkg do
    action [:install, :upgrade]
  end
end

if node[:ec2][:instance_id] == cfn['nfs']['server']['instance-id']
  include_recipe 'amimoto::nfs_server'
else
  include_recipe 'amimoto::nfs_client'
end


