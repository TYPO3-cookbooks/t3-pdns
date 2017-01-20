# adds the `dig` command that we use in the serverspec tests
package "dnsutils"

include_recipe "#{cookbook_name}::create_zone"
include_recipe "#{cookbook_name}::save_attributes"