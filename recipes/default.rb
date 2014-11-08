#
# Cookbook Name:: t3-pdns
# Recipe:: default
#
# Copyright (C) 2014 
#
# 
#

include_recipe "pdns::server"

# disable resolvconf which is not useful
# @see https://github.com/opscode-cookbooks/pdns/pull/11
resources("resolvconf[custom]").action :nothing

# Zones Directory
directory "/etc/powerdns/zones/" do
  mode 00755
  recursive true
end

# Zones
file "/etc/powerdns/zones/zones.conf" do
  mode 0644
  action :create_if_missing
end
