name             "t3-pdns"
maintainer       "Steffen Gebert"
maintainer_email "steffen.gebert@typo3.org"
license          "Apache2"
description      "Installs/Configures t3-pdns"
long_description "Installs/Configures t3-pdns"
source_url       "https://github.com/typo3-cookbooks/t3-pdns"
version          IO.read(File.join(File.dirname(__FILE__), 'VERSION')) rescue '0.0.1'

depends          "t3-base", "~> 0.2.68"

depends          "zabbix-custom-checks", "~> 0.2.6"

depends          "pdns", "= 2.4.1"
