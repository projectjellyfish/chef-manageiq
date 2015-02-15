#
# Cookbook Name:: manageiq
# Recipe:: default
#
# Copyright (C) 2015 Booz Allen Hamilton
#

# DB user definition
default['manageiq']['db_username']  = "evm"
default['manageiq']['db_password']  = "password"
default['manageiq']['ruby'] = "2.0.0"

# URL for manageiq code repo
default['manageiq']['code_repo']    = "https://github.com/ManageIQ/manageiq"

# RVM setup for miqbuilder
default['rvm']['user_installs']     = [{'user' => 'miqbuilder'}]

# Name of the BAH miq automate code file located in the cookbook files directory
default['manageiq']['automate_import'] = ''
default['manageiq']['domain'] = ''

# PostgreSQL Attributes
default['postgresql']['password']['postgres']       = node['manageiq']['db_password']
default['postgresql']['pg_hba']                     = [{type: 'local', db: 'all', user: 'all', addr: '', method: 'trust'}, {type: 'host', db: 'all', user: 'all', addr: '127.0.0.1/32 ', method: 'trust'}]
default['postgresql']['config']['port']             = 5432
default['postgresql']['host']                       = "127.0.0.1"
default['postgresql']['config']['listen_addresses'] = "*"
