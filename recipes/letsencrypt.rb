# install packages
%w{ python27-pip python27-virtualenv augeas-libs dialog gcc libffi-devel openssl-devel system-rpm-config }.each do | pkg |
  package pkg do
    action [:install, :upgrade]
  end
end

# install letsencript
letsencript_dir='/opt/letsencrypt'
bash 'letsencript-install' do
  action :nothing
  user "root"
  cwd "/tmp"
  code <<-EOH
    /usr/bin/virtualenv #{letsencript_dir}
    #{letsencript_dir}/bin/pip install letsencrypt
  EOH
  notifies :create, "link[/usr/local/bin/letsencrypt]", :immediately
end

link "/usr/local/bin/letsencrypt" do
  to "#{letsencript_dir}/bin/letsencrypt"
  action :nothing
end

directory letsencript_dir do
  owner 'root'
  group 'root'
  mode 00755
  recursive true
  action :create
  notifies :run, "bash[letsencript-install]", :immediately
end
