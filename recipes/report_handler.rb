### For debug


class Chef::Handler::LogReport < ::Chef::Handler
  def report
    Chef::Log.info '======= All Resources are following...'
    data[:all_resources].each.with_index do |r,idx|
      Chef::Log.info [idx, r.to_s].join(':')
    end
    Chef::Log.info '======= Update Resources are following...'
    data[:updated_resources].each.with_index do |r,idx|
      Chef::Log.info [idx, r.to_s].join(':')
    end
  end
end

Chef::Config[:report_handlers] << Chef::Handler::LogReport.new
Chef::Config[:report_handlers] << Chef::Handler::JsonFile.new
