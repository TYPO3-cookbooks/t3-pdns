
include_attribute "pdns::server"

# Listen on all Interfaces
default["pdns"]["server"]["local_address"] = "0.0.0.0"

# Bind Backend related Configuration
default["pdns"]["server_backend"] = "server"
default["pdns"]["server"]["launch"] = "bind"
default["pdns"]["server"]["bind_config"] = "/etc/powerdns/zones/zones.conf"

# disable some default Values which are not available in our Package
default["pdns"]["server"]["experimental_direct_dnskey"] = nil
default["pdns"]["server"]["experimental_json_interface"] = nil
default["pdns"]["server"]["experimental_logfile"] = nil
default["pdns"]["server"]["edns_subnet_option_number"] = nil
default["pdns"]["server"]["max_ent_entries"] = nil
default["pdns"]["server"]["searchdomains"] = nil

# Master related Configuration
default["pdns"]["server"]["master"] = "yes"
default["pdns"]["server"]["disable_axfr"] = "no"
default["pdns"]["server"]["allow_axfr_ips"] = ""

