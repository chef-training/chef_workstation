#
# Cookbook Name:: chef_workstation
# Spec:: default
#
# Copyright (c) 2015 The Authors, All Rights Reserved.

require 'spec_helper'

describe 'chef_workstation::yum_update' do
  context 'When all attributes are default on CentOS 6 it' do
    let(:chef_run) do
      runner = ChefSpec::ServerRunner.new(platform: 'centos', version: '6.6')
      runner.converge(described_recipe)
    end

    it 'does a yum update' do
      stub_command('yum check-update').and_return(false)
      expect { chef_run }.to_not raise_error
      expect(chef_run).to run_execute('yum update -y')
    end

    it 'converges successfully' do
      stub_command('yum check-update').and_return(false)
      expect { chef_run }.to_not raise_error
      chef_run # This should not raise an error
    end
  end
end
