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

  # it 'updates chef-provisioning and chef-provisioning-aws as the chef user' do
  #   expect(package 'chef-provisioning').to be_installed.by('gem')
  #   expect(package 'chef-provisioning-aws').to be_installed.by('gem')
  # end

  it 'creates the aws config directory' do
    expect(file '/home/chef/.aws').to be_directory
    expect(file '/home/chef/.aws').to be_owned_by('chef')
    expect(file '/home/chef/.aws').to be_grouped_into('chef')
  end

  it 'creates the aws config directory' do
    expect(file '/home/chef/.ssh').to be_directory
    expect(file '/home/chef/.ssh').to be_owned_by('chef')
    expect(file '/home/chef/.ssh').to be_grouped_into('chef')
  end

  it 'creates mock aws api credentials' do
    expect(file '/home/chef/.aws/config').to be_file
    expect(file '/home/chef/.aws/config').to be_owned_by('chef')
    expect(file '/home/chef/.aws/config').to be_grouped_into('chef')
    expect(file '/home/chef/.aws/config').to contain('aws_access_key_id = AKIAAABBCC')
    expect(file '/home/chef/.aws/config').to contain('aws_secret_access_key = Abc0123dEf4GhI')
  end

  it 'creates a mock aws ssh key' do
    expect(file '/home/chef/.ssh/aws_popup_chef.pem').to be_file
    expect(file '/home/chef/.ssh/aws_popup_chef.pem').to be_owned_by('chef')
    expect(file '/home/chef/.ssh/aws_popup_chef.pem').to be_grouped_into('chef')
    expect(file '/home/chef/.ssh/aws_popup_chef.pem').to contain('ThisIsNotRealContent')
  end
end
