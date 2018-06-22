#
# Cookbook Name:: t3-pdns
# Recipe:: default
#
# Copyright (C) 2014 
#
# 
#

include_recipe "t3-base"

package 'bind9utils' # for named-checkzone

include_recipe "pdns::default"

# Zones (/etc/powerdns/zones.conf)
file node['pdns']['authoritative']['config']['bind_config'] do
  mode 0644
  action :create_if_missing
end

# Zones Directory
directory "/etc/powerdns/zones/" do
  mode 00755
  recursive true
end

include_recipe "zabbix-custom-checks::pdns" if node['t3-base']['flags']['production']
