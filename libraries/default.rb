include Chef::Mixin::ShellOut

## returns mysql parameter
def get_mysql_variable(name)
   result = shell_out(%Q{mysql -NBe "show variables where Variable_name = '#{name}' ;"})
   result.stdout.split[1]
end

## returns mysql parameter
# example: to_mysql_bytes('16M') => "16777216"
def to_mysql_bytes(str)
  case str[-1].downcase
  when 'k'
    str.to_i.kilobytes.to_s
    ret = str.to_i * 1024
    ret.to_s
  when 'm'
    ret = str.to_i * 1024 * 1024
    ret.to_s
  when 'g'
    ret = str.to_i * 1024 * 1024 * 1024
    ret.to_s
  else
    str
  end
end

def restart_mysql_with_flush_ib_logfiles
  service "mysql" do
    action :stop
  end

  %w{ ib_logfile0 ib_logfile1 }.each do | file_name |
    file "/var/lib/mysql/" + file_name do
      action :delete
    end
  end

  service "mysql" do
    action :start
  end
end
