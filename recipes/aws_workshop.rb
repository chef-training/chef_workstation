#
# Cookbook Name:: chef_workstation
# Recipe:: aws_workshop
#
# Author:: Ned Harris (<nharris@chef.io>)
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

include_recipe 'chef_workstation'
chef_user = node['chef_workstation']['user']

# The latest chef-provisioning-aws may not be in ChefDK
# (note: shell init may not be yet available, so we have to fake it)
execute 'update_chef_provisioning' do
  command "sudo -u #{chef_user} chef gem update chef-provisioning chef-provisioning-aws"
  user chef_user
  cwd "/home/#{chef_user}"
  environment(
    'PATH' => '/opt/chefdk/bin:/opt/chefdk/embedded/bin:/usr/local/bin:/bin:/usr/bin:/usr/local/sbin:/usr/sbin:/sbin',
    'GEM_ROOT' => '/opt/chefdk/embedded/lib/ruby/gems/2.1.0',
    'GEM_HOME' => "/home/#{chef_user}/.chefdk/gem/ruby/2.1.0",
    'GEM_PATH' => "/home/#{chef_user}/.chefdk/gem/ruby/2.1.0:/opt/chefdk/embedded/lib/ruby/gems/2.1.0"
  )
  not_if "sudo -u #{chef_user} chef gem list chef-provisioning | grep 'chef-provisioning (' | grep ','"
end

# mock credentials for AWS workshops
%w(aws ssh).each do |dotdir|
  directory "/home/#{chef_user}/.#{dotdir}" do
    user chef_user
    group chef_user
  end
end

template "/home/#{chef_user}/.aws/config" do
  source 'config.erb'
  owner chef_user
  group chef_user
  mode '0644'
end

template "/home/#{chef_user}/.ssh/aws_popup_chef.pem" do
  source 'aws_popup_chef.erb'
  owner chef_user
  group chef_user
  mode '0644'
end
