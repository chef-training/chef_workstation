require 'spec_helper'

describe 'chef_workstation::yum_update' do
  describe command('yum check-update') do
    its(:exit_status) { should eq 0 }
  end
end
