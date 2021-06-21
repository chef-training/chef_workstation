#
# Cookbook:: chef_workstation
# Spec:: default
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
  context 'When all attributes are default on CentOS 6 it' do
    let(:chef_run) do
      runner = ChefSpec::ServerRunner.new(platform: 'centos', version: '6')
      runner.converge(described_recipe)
    end
    let(:sshd_config) { chef_run.template('/etc/ssh/sshd_config') }

    it 'creates a chef user' do
      expect(chef_run).to create_user('chef')
    end

    # #Not the right test -- it needs to inspect file content, not see that chef rendered
    # it 'grants sudo permission to the chef user' do
    #   expect(chef_run).to render_file('/etc/sudoers').with_content('chef ALL=(ALL) NOPASSWD:ALL')
    # end
    #
    # #Not the right test -- HTF do I see that a package would be installed by some library?
    # it 'installs the ChefDK' do
    #   expect(chef_run).to have_package('chefdk')
    # end

    it 'creates the chef user bashrc' do
      expect(chef_run).to create_template('/home/chef/.bashrc').with(
        user:  'chef',
        group: 'chef',
        mode:  '0644'
      )
    end

    it 'enables chefdk shell init' do
      expect(chef_run).to render_file('/home/chef/.bashrc')
        .with_content('eval "$(chef shell-init bash)"')
    end

    it 'overwrites the default sshd_config' do
      expect(chef_run).to create_template('/etc/ssh/sshd_config').with(
        user:  'root',
        group: 'root',
        mode:  '0644'
      )
    end

    it 'enables ssh password auth' do
      expect(chef_run).to render_file('/etc/ssh/sshd_config')
        .with_content('PasswordAuthentication yes')
    end

    it 'does nothing to the ssh service settings' do
      sshd = chef_run.service('sshd')
      expect(sshd).to do_nothing
    end

    # it 'sends a restart notification to the ssh serivce' do
    #   sshd_config = chef_run.template('/etc/ssh/sshd_config')
    #   sshd = chef_run.service('sshd')
    #   expect(sshd_config).to notify(sshd).to(:restart)
    # end

    it 'removes the chef-apply example packages' do
      expect(chef_run).to remove_package('vim')
      expect(chef_run).to remove_package('emacs')
      expect(chef_run).to remove_package('nano')
    end

    it 'disables selinux' do
      expect(chef_run).to render_file('/etc/selinux/config')
        .with_content('SELINUXTYPE=targeted')
      expect(chef_run).to render_file('/etc/selinux/config')
        .with_content('SELINUX=disabled')
    end

    it 'stops and disables the iptables service' do
      expect(chef_run).to stop_service('iptables')
      expect(chef_run).to disable_service('iptables')
    end

    it 'converges successfully' do
      chef_run # This should not raise an error
    end
  end
end
