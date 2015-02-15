#
# Cookbook Name:: manageiq
# Recipe:: default
#
# Copyright (C) 2015 Booz Allen Hamilton
#

include_recipe "git"
include_recipe "yum"
include_recipe "yum-epel"
include_recipe "iptables"
include_recipe "postgresql::client"
include_recipe "postgresql::server"
include_recipe "postgresql::ruby"
include_recipe "database::postgresql"
include_recipe "xml"
include_recipe "ntp"
include_recipe "memcached"

# Set SSH rule immediately in case of converge fail
iptables_rule "ssh"

node.set['postgresql']['password'] = {postgres: node['postgresql']['password']}

#Create Test Database
postgresql_connection_info = {
  :host     => node['postgresql']['host'],
  :port     => node['postgresql']['config']['port'],
  :username => 'postgres',
  :password => node['postgresql']['password']
}

postgresql_database_user node["manageiq"]["db_username"] do
  connection postgresql_connection_info
  password node['manageiq']['db_password']
  action :create
end

postgresql_database 'vmdb_test' do
  connection postgresql_connection_info
  template 'DEFAULT'
  encoding 'DEFAULT'
  tablespace 'DEFAULT'
  connection_limit '-1'
  owner node["manageiq"]["db_username"]
  action :create
end

postgresql_database 'vmdb_production' do
  connection postgresql_connection_info
  template 'DEFAULT'
  encoding 'DEFAULT'
  tablespace 'DEFAULT'
  connection_limit '-1'
  owner node["manageiq"]["db_username"]
  action :create
end

postgresql_database 'vmdb_development' do
  connection postgresql_connection_info
  template 'DEFAULT'
  encoding 'DEFAULT'
  tablespace 'DEFAULT'
  connection_limit '-1'
  owner node["manageiq"]["db_username"]
  action :create
end

#Create miqbuilder user
user "miqbuilder" do
  comment "user to build and run the ManageIQ project"
  home "/home/miqbuilder"
  shell "/bin/bash"
  action :create
end

sudo 'miqbuilder' do
  user 'miqbuilder'
  nopasswd true
end

#Create directory for checking out manageiq code
directory "/opt/manageiq" do
  owner "miqbuilder"
  group "miqbuilder"
  mode 00755
  action :create
  recursive true
end

#Pull down the manageiq repo
git "/opt/manageiq" do
  repository node["manageiq"]["code_repo"]
  revision "master"
  action :sync
end

#Install RVM
include_recipe "rvm"
include_recipe "rvm::user_install"

#ruby install
rvm_ruby node['manageiq']['ruby'] do
  user    "miqbuilder"
  action  :install
end

#Make Ruby 2.0.0 the default ruby
rvm_default_ruby node['manageiq']['ruby'] do
  user    "miqbuilder"
  action :create
end

execute "updateperms" do
  command "chown -R miqbuilder.miqbuilder /opt/manageiq;chmod -R 755 /opt/manageiq;chown -R miqbuilder.miqbuilder /home/miqbuilder;chmod -R 755 /home/miqbuilder"
  action :run
end

#Install latest ruby-graphviz
rvm_gem "ruby-graphviz" do
  user    "miqbuilder"
  ruby_string node['manageiq']['ruby']
  action      :install
  notifies :run, "execute[updateperms]", :immediately
end

rvm_shell "miq vmdb bundle install" do
  ruby_string node['manageiq']['ruby']
  user        "miqbuilder"
  group       "miqbuilder"
  cwd         "/opt/manageiq/vmdb"
  code        %{bundle install --without qpid}
end

rvm_shell "miq rake build" do
  ruby_string node['manageiq']['ruby']
  user        "miqbuilder"
  group       "miqbuilder"
  cwd         "/opt/manageiq/"
  code        %{vmdb/bin/rake build:shared_objects}
end

rvm_shell "miq vmdb bundle install after rake" do
  ruby_string node['manageiq']['ruby']
  user        "miqbuilder"
  group       "miqbuilder"
  cwd         "/opt/manageiq/vmdb"
  code        %{bundle install --without qpid}
end

template "/opt/manageiq/vmdb/config/database.pg.yml" do
  source 'database.pg.yml.erb'
  mode 0755
  owner 'miqbuilder'
  group 'miqbuilder'
  variables(
    :db_user	=> node["manageiq"]["db_username"]
  )
end

rvm_shell "miq vmdb rake db migrate" do
  ruby_string node['manageiq']['ruby']
  user        "miqbuilder"
  group       "miqbuilder"
  cwd         "/opt/manageiq/vmdb"
  code        %{bin/rake db:migrate}
end

#Start Manageiq
rvm_shell "miq vmdb rake evm start" do
  ruby_string node['manageiq']['ruby']
  user        "miqbuilder"
  group       "miqbuilder"
  cwd         "/opt/manageiq/vmdb"
  code        %{bin/rake evm:start}
end

unless node['manageiq']['automate_import'].empty?
  #untar the file
  execute "untar-miq-automate" do
    command "tar -zxf /tmp/" + node['manageiq']['bah_miq_automate_latest'] + " -C /tmp --strip-components 2"
    action :nothing
  end

  #save the file to the /tmp directory
  cookbook_file node['manageiq']['automate_import'] do
    path "/tmp/" + node['manageiq']['automate_import']
    action :create_if_missing
    notifies :run, "execute[untar-miq-automate]", :immediately
  end

  #Import BAH Miq Automate Code
  rvm_shell "miq vmdb rake evm automate import code" do
    ruby_string node['manageiq']['ruby']
    user        "miqbuilder"
    group       "miqbuilder"
    cwd         "/opt/manageiq/vmdb"
    code        %{bin/rake evm:automate:import DOMAIN=#{node['manageiq']['domain']} IMPORT_DIR=/tmp/domains PREVIEW=false IMPORT_AS=#{node['manageiq']['domain']}}
  end
end

# Setup IPTABLES to allow access via web
iptables_rule "manageiq"
