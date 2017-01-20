actions :create, :delete
default_action :create

attribute :name,
          :name_attribute => true,
          :kind_of        => String

attribute :soa,
          :kind_of        => String,
          :default        => "ns"

attribute :contact,
          :kind_of        => String,
          :required       => true

attribute :global_ttl,
          :kind_of        => Integer,
          :default        => 3600

attribute :nameserver,
          :kind_of        => Array,
          :default        => []

attribute :mail_exchange,
          :kind_of        => Array,
          :default        => []

attribute :records,
          :kind_of        => Array,
          :default        => []

attribute :source,
          :kind_of        => String,
          :default        => "zone.erb"

attribute :cookbook,
          :kind_of        => String,
          :default        => "t3-pdns"

attr_accessor :exists