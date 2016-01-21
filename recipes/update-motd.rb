%w{ 30-banner 35-middlewares 70-available-updates 75-system-update }.each do | file_name |
  template "/etc/update-motd.d/" + file_name do
    variables(
      :hhvm => node[:hhvm][:enabled],
      :php => node[:phpfpm][:enabled]
    )
    source "update-motd.d/" + file_name + ".erb"
    mode 00755
  end
end

bash "update-motd" do
  user "root"
  cwd "/tmp"
  code <<-EOH
    update-motd
  EOH
end
