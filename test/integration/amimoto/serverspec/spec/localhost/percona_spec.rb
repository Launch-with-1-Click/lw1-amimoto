require ::File.expand_path('../../spec_helper', __FILE__)

## Repo Percona

describe yumrepo('percona') do
  it { should exist }
  it { should be_enabled }
end

describe command('mysqladmin ping') do
  it { should return_exit_status 0 }
end

describe command('mysqld -V') do
  it { should return_stdout /Percona\ Server/ }
end

describe service('mysql') do
  it { should be_enabled }
  it { should be_running }
  it { should be_monitored_by('monit') }
end
