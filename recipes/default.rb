#
# Cookbook Name:: amimoto
# Recipe:: default
#
# Copyright 2013, DigitalCube Co. Ltd.
#
# All rights reserved - Do Not Redistribute
#
include_recipe 'amimoto::timezone'
include_recipe 'amimoto::iptables'
include_recipe 'amimoto::sysctl'
include_recipe 'amimoto::repos'
template "/etc/sysconfig/i18n" do
  source "i18n.erb"
end

%w{ zip unzip wget git openssl }.each do | pkg |
  package pkg do
    action [:install, :upgrade]
  end
end

# memcached install
node[:memcached][:packages].each do | pkg |
  package pkg do
    action [:install, :upgrade]
  end
end

# install mysql
include_recipe 'amimoto::mysql'

# install nginx
include_recipe 'amimoto::nginx'

# install php
include_recipe 'amimoto::php'

# install monit
include_recipe 'amimoto::monit'

# install wp-cli
include_recipe 'amimoto::wpcli'
