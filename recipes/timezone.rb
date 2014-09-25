link "/etc/localtime" do
	to "/usr/share/zoneinfo/" + node[:timezone]
end

clock = Chef::Util::FileEdit.new("/etc/sysconfig/clock")
clock.search_file_replace_line(/^ZONE=.*$/, "ZONE=\"#{node[:timezone]}\"")
clock.write_file
