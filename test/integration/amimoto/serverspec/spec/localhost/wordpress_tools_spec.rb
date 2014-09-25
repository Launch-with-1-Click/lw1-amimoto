require ::File.expand_path('../../spec_helper', __FILE__)

describe command('wp --version --allow-root') do
  it { should return_exit_status 0 }
  it { should return_stdout /^WP-CLI/ }
end
