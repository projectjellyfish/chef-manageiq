name             'chef-manageiq'
maintainer       'Booz Allen Hamilton'
maintainer_email 'jellyfishopensource@bah.com'
license          'Apache 2.0'
description      'Installs/Configures ManageIQ'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          '1.0.0'
supports         'rhel'
supports         'centos'

depends "yum"
depends "yum-epel"
depends "postgresql"
depends "iptables"
depends "database"
depends "rvm"
depends "xml"
depends "git"
depends "ntp"
depends "memcached"
depends "sudo"
