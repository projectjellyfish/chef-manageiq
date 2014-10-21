manageiq Cookbook
=================
Pulls down the latest ManageIQ code, builds the code, installs the dependencies, and then starts the evm processes.

Requirements
------------
### Platforms
Tested on RHEL 6.5 and CentOS 6.5. Should work on any Red Hat family distributions.

### Cookbooks
- git
- yum
- yum-epel
- iptables
- postgresql
- database
- xml
- ntp
- memcached

Attributes
----------
######Attributes specifically for ManageIQ
- `default["manageiq"]["db_username"]` - Username for the ManageIQ database user (default: "evm")
- `default['manageiq']['db_password']` - password for the ManageIQ database user
- `default['manageiq']['code_repo']` - GIT Repo URL used to build the server

######Attributes for the RVM cookbook
- `default['rvm']['user_installs']` - Username for the user who is building and running the ManageIQ processes

######Attributes for the PostgreSQL Database
- `default['postgresql']['password']['postgres']` - Set the root password for the database (default: sets to the manageiq/db_password)
- `default["postgresql"]["pg_hba"]` - Configures the pg_hba file to allow incoming connections
- `default["postgresql"]["config"]["port"]` - Database Port (default: 5432)
- `default["postgresql"]["host"]` - Host Information (default: 127.0.0.1)
- `default['postgresql']['config']['listen_addresses']` - Listen Addresses for the database (default: "*")

Usage
-----
Simply add `role[manageiq]` to a run list.


Deploying a ManageIQ Server
-----------
This section details "quick deployment" steps.

1. Clone this repository from GitHub:

        $ git clone git@github.com:booz-allen-hamilton/chef-manageiq.git

2. Change directory to the repo folder

        $ cd chef-manageiq

3. Create a solo.rb file

		$ vim solo.rb

			file_cache_path "/root/chef-repo"
			cookbook_path "/root/chef-repo/cookbooks"


4. Install dependencies:

        Download the dependent cookbooks from Chef Supermarket

5. Install Chef Client

		$ curl -L https://www.opscode.com/chef/install.sh | sudo bash

6. Run Chef-solo:

		$ chef-solo -c solo.rb -j roles/manageiq.json


License & Authors
-----------------
- Author:: Chris Kacerguis
- Author:: Mandeep Bal

```text
Copyright:: 2014, Booz Allen Hamilton

For more information on the license, please refer to the LICENSE.txt file in the repo
```
