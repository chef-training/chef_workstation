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

describe 'chef_workstation::default' do
  it 'creates a chef user' do
    expect(user 'chef').to exist
    expect(user 'chef').to have_home_directory('/home/chef')
    expect(user 'chef').to have_login_shell('/bin/bash')
  end

  it 'grants sudo permission to the chef user' do
    expect(file '/etc/sudoers.d/chef_user').to contain('chef ALL=(ALL) NOPASSWD:ALL')
  end

  it 'installs the chefdk package' do
    expect(package 'chefdk').to be_installed
  end

  it 'creates the chef user bashrc' do
    expect(file '/home/chef/.bashrc').to be_file
    expect(file '/home/chef/.bashrc').to be_owned_by('chef')
    expect(file '/home/chef/.bashrc').to be_grouped_into('chef')
    expect(file '/home/chef/.bashrc').to be_mode(644)
    expect(file '/home/chef/.bashrc').to contain('eval "$(chef shell-init bash)"')
  end

  it 'overwrites the default sshd_config' do
    expect(file '/etc/ssh/sshd_config').to be_file
    expect(file '/etc/ssh/sshd_config').to be_owned_by('root')
    expect(file '/etc/ssh/sshd_config').to be_grouped_into('root')
    expect(file '/etc/ssh/sshd_config').to be_mode(644)
    expect(file '/etc/ssh/sshd_config').to contain('PasswordAuthentication yes')
  end

  it 'should have a running sshd service' do
    expect(service 'sshd').to be_running
  end

  it 'removes the chef-apply example packages' do
    expect(package 'vim').to_not be_installed
    expect(package 'emacs').to_not be_installed
    expect(package 'nano').to_not be_installed
  end

  if os[:family] == 'centos'
    it 'disables selinux' do
      expect(file '/etc/selinux/config').to be_file
      expect(file '/etc/selinux/config').to be_owned_by('root')
      expect(file '/etc/selinux/config').to be_grouped_into('root')
      expect(file '/etc/selinux/config').to contain('SELINUXTYPE=targeted')
      expect(file '/etc/selinux/config').to contain('SELINUX=disabled')
    end
  end
end
