#
# Cookbook Name:: amimoto
# Recipe:: default
#
# Copyright 2013, DigitalCube Co. Ltd.
#
# All rights reserved - Do Not Redistribute
#
include_recipe 'amimoto::repos'
if node[:virtualization][:system] != 'docker'
  include_recipe 'amimoto::timezone'
  include_recipe 'amimoto::iptables'
  include_recipe 'amimoto::sysctl'
  template "/etc/sysconfig/i18n" do
    source "i18n.erb"
  end
  #template "/etc/sudoers" do
  #  source "sudoers.erb"
  #end
end

%w{ zip unzip wget git openssl bash }.each do | pkg |
  package pkg do
    action [:install, :upgrade]
    notifies :run, 'bash[update-motd]', :delayed
  end
end

# create www Group
group node[:web][:group] do
  members ['ec2-user',node[:web][:user]]
  action :create
end

# install mysql
include_recipe 'amimoto::mysql'

# install httpd
include_recipe 'amimoto::httpd'
include_recipe 'amimoto::httpd_default'

# install nginx
include_recipe 'amimoto::nginx'
#include_recipe 'amimoto::nginx_default'

# install php
if node[:hhvm][:enabled]
  include_recipe 'amimoto::hhvm'
else
  if node[:mod_php7][:enabled]
    include_recipe 'amimoto::mod_php7'
  else
    include_recipe 'amimoto::php'
  end
end

if (node[:memory][:total].to_i / 1024) > 1024
  # memcached install
  if node[:memcached][:enabled]
    include_recipe 'amimoto::memcached'
  end

  # redis install
  if node[:redis][:enabled]
    include_recipe 'amimoto::redis'
  end
end

# install goofys
if node[:goofys][:install]
  include_recipe 'amimoto::goofys'
end

# install letsencrypt
if node[:letsencrypt][:install]
  include_recipe 'amimoto::letsencrypt'
end

# install monit
include_recipe 'amimoto::monit'

# utilitie
%w{ cf_option_check.php cf_patern_check.php }.each do | file_name |
  template "/opt/local/" + file_name do
    source "cfn/" + file_name + ".erb"
  end
end

# install wp-cli
include_recipe 'amimoto::wpcli'

# install phpMyAdmin
include_recipe 'amimoto::phpmyadmin'

# update-motd
include_recipe 'amimoto::update-motd'
