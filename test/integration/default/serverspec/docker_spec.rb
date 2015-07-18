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

describe 'chef_workstation::docker' do

  it 'creates the docker group with chef as a member' do
    expect(group 'docker').to exist
    expect(user 'chef').to belong_to_group('docker')
  end

  it 'installs docker package dependencies' do
    expect(package 'xz').to be_installed
    expect(package 'libcgroup').to be_installed
  end

  it 'installs the docker package' do
    expect(package 'docker-engine').to be_installed
  end

  it 'starts and enables the docker service' do
    expect(service 'docker').to be_running
    expect(service 'docker').to be_enabled
  end

  it 'pulls a centos 6 docker image' do
    expect(docker_image 'centos:6').to exist
  end

  # it 'installs the kitchen-docker gem' do
  #   expect(package 'kitchen-docker').to be_installed.by('gem')
  # end
end
