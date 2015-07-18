#
# Cookbook Name:: chef_workstation
# Spec:: docker
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

describe 'chef_workstation::docker' do
  context 'When all attributes are default on CentOS 6 it' do
    let(:chef_run) do
      runner = ChefSpec::ServerRunner.new(platform: 'centos', version: '6.6', file_cache_path: '/tmp/chef/cache')
      runner.converge(described_recipe)
    end
    before(:each) do
      stub_my_guards
    end

    it 'includes the chef_workstation::default recipe' do
      expect(chef_run).to include_recipe('chef_workstation::default')
    end

    it 'includes the chef_workstation::yum_update recipe' do
      expect(chef_run).to include_recipe('chef_workstation::yum_update')
    end

    it 'creates the docker group with chef as a member' do
      expect(chef_run).to create_group('docker').with(
        members: ['chef'],
        append:  true
      )
    end

    it 'installs docker package dependencies' do
      expect(chef_run).to install_package('xz')
      expect(chef_run).to install_package('libcgroup')
    end

    it 'downloads the specified docker-engine rpm' do
      expect(chef_run).to create_remote_file('/tmp/chef/cache/docker-engine.rpm')
    end

    it 'installs the docker-engine package' do
      expect(chef_run).to install_rpm_package('docker-engine')
    end

    it 'starts and enables the docker service' do
      expect(chef_run).to start_service('docker')
      expect(chef_run).to enable_service('docker')
    end

    it 'pulls a centos 6 docker image' do
      expect(chef_run).to run_execute('docker pull centos:6')
    end

    it 'installs the kitchen-docker gem' do
      expect(chef_run).to install_gem_package('kitchen-docker').with(
        gem_binary: '/opt/chefdk/embedded/bin/gem',
        options:    '--no-user-install'
      )
    end

    # it 'sends a restart notification to the docker serivce' do
    #   gem_package = chef_run.gem_package('kitchen-docker')
    #   docker_service = chef_run.service('docker')
    #   expect(gem_package).to notify(docker_service).to(:restart)
    # end

    it 'converges successfully' do
      chef_run # This should not raise an error
    end
  end
end
