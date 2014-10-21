name             'manageiq'
maintainer       'Mandeep Bal'
maintainer_email 'bal_mandeep@bah.com'
license          'All rights reserved'
description      'Installs/Configures ManageIQ'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          '0.1.0'

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
