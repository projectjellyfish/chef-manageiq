name             'chef-manageiq'
maintainer       'Booz Allen Hamilton'
maintainer_email 'jellyfishopensource@bah.com'
license          'GPL v2'
description      'Installs/Configures ManageIQ'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          '0.1.2'
supports         'rhel'

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
