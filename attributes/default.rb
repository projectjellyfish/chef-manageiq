# General Attributes for ManageIQ cookbook

# DB user definition
default["manageiq"]["db_username"]  = "evm"
default['manageiq']['db_password']  = "password"

# URL for manageiq code repo
default['manageiq']['code_repo']    = "https://github.com/booz-allen-hamilton/manageiq"

#RVM setup for miqbuilder
default['rvm']['user_installs']     = [{'user' => 'miqbuilder'}]

# Automate Code Attributes
default['manageiq']['automate_code_url']    = "https://s3.amazonaws.com/dpi-releases/BAHdatastore_20141024.zip"
default['manageiq']['automate_code_domain'] = "BAH"

# PostgreSQL Attributes
default['postgresql']['password']['postgres']       = node['manageiq']['db_password']
default["postgresql"]["pg_hba"]                     = [{type: 'local', db: 'all', user: 'all', addr: '', method: 'trust'}, {type: 'host', db: 'all', user: 'all', addr: '127.0.0.1/32 ', method: 'trust'}]
default["postgresql"]["config"]["port"]             = 5432
default["postgresql"]["host"]                       = "127.0.0.1"
default['postgresql']['config']['listen_addresses'] = "*"
