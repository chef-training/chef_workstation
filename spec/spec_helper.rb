require 'chefspec'
require 'chefspec/berkshelf'

module CommonStubs
  def stub_my_guards
    stub_command('yum check-update').and_return(false)
    stub_command('docker images | grep centos').and_return(false)
    stub_command('rpm -q docker-engine').and_return(false)
  end
end

RSpec.configure do |config|
  config.include CommonStubs
  config.before(:all) do
    stub_my_guards
  end
end

at_exit { ChefSpec::Coverage.report! }
