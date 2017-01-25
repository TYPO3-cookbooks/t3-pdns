default['pdns']['flavor'] = 'authoritative'
default['pdns']['authoritative']['config']['allow_recursion'] = '127.0.0.1'
#<> Just a test value
default['pdns']['authoritative']['config']['allow_axfr_ips'] = ['192.168.1.1']
default['pdns']['authoritative']['config']['disable_axfr'] = false
#<> Turn on master functionality
default['pdns']['authoritative']['config']['disable_axfr'] = false

# default['pdns']['authoritative']['config']['local_ipv6'] = "::1 #{node[:ip6address]}"
default['pdns']['authoritative']['config']['local_ipv6'] = "::"

#<> Bind zone configuration (override: this is set with default priority in the authoritative recipe)
override['pdns']['authoritative']['config']['bind_config'] = '/etc/powerdns/zones.conf'
