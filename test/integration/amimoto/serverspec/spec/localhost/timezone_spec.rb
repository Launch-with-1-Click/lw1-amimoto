require ::File.expand_path('../../spec_helper', __FILE__)

describe command('date +%Z') do
  it { should return_stdout 'JST' }
end
