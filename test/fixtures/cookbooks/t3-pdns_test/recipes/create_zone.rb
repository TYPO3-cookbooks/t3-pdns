include_recipe "t3-pdns::default"

t3_pdns_zone "example.com" do
  soa            "ns"
  contact        "admin.example.com"
  global_ttl     300
  mail_exchange  [{:host => "mail.example.com", :priority => 20}]
  nameserver     ["a.com"]
  records        ([
      {:name => "",    :type => "A",     :value => "1.2.3.4"},
      {:name => "www", :type => "CNAME", :value => "example.org."},
    ])
end