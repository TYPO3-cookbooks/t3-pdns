control 'pdns-1' do
  title 'PowerDNS Setup'

  describe package('pdns-server') do
    it { should be_installed }
  end

  # this is pretty ugly.. but well..
  sleep 10

  # not working in docker
  # describe service('pdns') do
  #   it { should be_running }
  # end

  # great DSL, dear inspec!
  # Verify that one of each of these processes is running
  %w{pdns_server pdns_server-instance}.each do |process|
    describe processes(process) do
      its('list.length') { should eq(1) }
    end
  end


  describe port(53) do
    its('protocols') { should include 'tcp'}
    its('protocols') { should include 'tcp6'}
    its('protocols') { should include 'udp'}
    its('protocols') { should include 'udp'}
    # does not work in docker
    # its('processes') { should include 'pdns_server-in' }
  end

  # this file is created in t3-pdns_test::save_attributes
  node = json('/tmp/kitchen_chef_node.json').params

  # read out all IP addresses of this node
  ips = node['automatic']['network']['interfaces'].select { |iface_name, iface_data|
    # remove interfaces that have no address (e.g. because it's down)
    iface_data.key? 'addresses'
  }.map { |iface_name, iface_data|
    # loop over all addresses
    iface_data['addresses'].select { |address, address_data|
      # pick only inet and inet6
      ['inet', 'inet6'].include? address_data['family']
    }.keys.flatten # keys are the addresses, flatten the array of arrays
  }

  # we search for the line 'example.com IN A 1.2.3.4' (and match against the IP only)
  ips.flatten.each do |local_ip|
    describe command('dig example.com @' + local_ip) do
      its(:stdout) { should match /example\.com\..*\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}/ }
    end
  end

  describe file('/etc/powerdns/pdns.conf') do
    its('content') { should include 'allow-axfr-ips'}
    its('content') { should include 'master=yes'}
  end

  describe file('/var/log/syslog') do
    its('content') { should include 'Master/slave communicator launching' }
  end
end
