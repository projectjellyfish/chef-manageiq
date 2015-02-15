#
# Cookbook Name:: manageiq
# Recipe:: default
#
# Copyright (C) 2015 Booz Allen Hamilton
#

require 'serverspec'

# Required by serverspec
set :backend, :exec

set :path, '/sbin:/usr/sbin:/usr/local/sbin:$PATH'
