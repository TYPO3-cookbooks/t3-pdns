include_recipe "t3-pdns::default"

t3_pdns_zone "example.com" do
  soa            "ns"
  contact        "admin.example.com"
  global_ttl     300
  mail_exchange  [{:host => "mail.example.com.", :priority => 20}]
  nameserver     ["ns.example.org."]
  records        ([
      {:name => "@",    :type => "A",     :value => "192.0.2.1"},
      {:name => "www",  :type => "CNAME", :value => "example.org."},
      {:name => "mail", :type => "A",     :value => "192.0.2.2"},
      {:name => "ns",   :type => "A",     :value => "192.0.2.3"},
    ])
end
