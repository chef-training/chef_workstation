#
# Cookbook Name:: chef_workstation
# Spec:: aws_workshop
#
# Author:: George Miranda (<gmiranda@chef.io>)
# Copyright:: Copyright (c) 2015 Chef Software, Inc.
# License:: MIT
#
# Permission is hereby granted, free of charge, to any person obtaining
# a copy of this software and associated documentation files (the
# "Software"), to deal in the Software without restriction, including
# without limitation the rights to use, copy, modify, merge, publish,
# distribute, sublicense, and/or sell copies of the Software, and to
# permit persons to whom the Software is furnished to do so, subject to
# the following conditions:
#
# The above copyright notice and this permission notice shall be
# included in all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
# EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
# MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
# NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
# LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
# OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
# WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

require 'spec_helper'

describe 'chef_workstation::aws_workshop' do
  context 'When all attributes are default on CentOS 6 it' do
    let(:chef_run) do
      runner = ChefSpec::ServerRunner.new(platform: 'centos', version: '6.6')
      runner.converge(described_recipe)
    end

    it 'includes the chef_workstation::default recipe' do
      expect(chef_run).to include_recipe('chef_workstation::default')
    end

    it 'updates chef-provisioning and chef-provisioning-aws as the chef user' do
      expect(chef_run).to run_execute('update_chef_provisioning').with(user: 'chef')
      expect(chef_run).to run_execute('update_chef_provisioning').with(cwd: '/home/chef')
    end

    it 'creates the aws config directory' do
      expect(chef_run).to create_directory('/home/chef/.aws').with(
        user: 'chef',
        group: 'chef'
    )
    end

    it 'creates the ssh config directory' do
      expect(chef_run).to create_directory('/home/chef/.ssh').with(
        user: 'chef',
        group: 'chef'
    )
    end

    it 'creates mock aws api credentials' do
      expect(chef_run).to render_file('/home/chef/.aws/config')
        .with_content('aws_access_key_id = AKIAAABBCC')
      expect(chef_run).to render_file('/home/chef/.aws/config')
        .with_content('aws_secret_access_key = Abc0123dEf4GhI')
    end

    it 'creates a mock aws ssh key' do
      expect(chef_run).to render_file('/home/chef/.ssh/aws_popup_chef.pem')
        .with_content('ThisIsNotRealContent')
    end

    it 'converges successfully' do
      chef_run # This should not raise an error
    end
  end
end
