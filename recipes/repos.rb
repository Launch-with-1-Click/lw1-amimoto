# Percona
bash 'percona.repo' do
    not_if 'rpm -qi gpg-pubkey-* | grep Percona'
    code <<-EOC
        rpm --import http://www.percona.com/downloads/RPM-GPG-KEY-percona
    EOC
end
template '/etc/yum.repos.d/Percona.repo' do
  source 'yum/Percona.repo.erb'
  action :create
end

# epel
template '/etc/yum.repos.d/epel.repo' + file_name do
  source 'yum/' + file_name + '.erb'
  action :create
end

# remove rpmforge
file "/etc/yum.repos.d/rpmforge.repo" do
    action :delete
end

# remi
bash 'remi.repo' do
    not_if 'rpm -qi gpg-pubkey-* | grep Remi'
    code <<-EOC
        rpm --import http://rpms.famillecollet.com/RPM-GPG-KEY-remi
    EOC
end
template '/etc/yum.repos.d/remi.repo' do
  source 'yum/remi.repo.erb'
  action :create
end
%w{ remi-php54 remi-php55 remi-php56 remi-php70 remi-php71 }.each do | file_name |
  file '/etc/yum.repos.d/' + file_name + '.repo' do
    action :delete
  end
end


# amimoto-nginx-mainline
template "/etc/yum.repos.d/amimoto-nginx-mainline.repo" do
  source "yum/amimoto-nginx-mainline.repo.erb"
end

# RHEL
if %w(redhat).include?(node[:platform])
  # nginx
  template '/etc/yum.repos.d/nginx.repo' do
    source 'yum/nginx.repo.erb'
    action :create
  end

  %w(libmcrypt).each do |pkg|
    yum_package pkg do
      action [:install, :upgrade]
      options '--enablerepo=epel'
      flush_cache [:before]
    end
  end

  # iuscommunity
  template '/etc/yum.repos.d/iuscommunity.repo' do
    source 'yum/iuscommunity.repo.erb'
    action :create
  end
end
