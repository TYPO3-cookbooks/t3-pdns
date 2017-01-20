control 'pdns-1' do
  title 'PowerDNS Setup'

  describe package('pdns-server') do
    it { should be_installed }
  end

  # this is pretty ugly.. but well..
  sleep 10

  describe service('pdns') do
    it { should be_running }
  end

  describe port(53) do
    its('protocols') { should include 'tcp'}
    its('protocols') { should include 'tcp6'}
    its('protocols') { should include 'udp'}
    its('protocols') { should include 'udp'}
    its('processes') { should include 'pdns_server-in' }
  end

  # this file is created in t3-pdns_test::save_attributes
  node = json('/tmp/kitchen_chef_node.json').params

  # read out all IP addresses of this node
  ips = node['automatic']['network']['interfaces'].map { |iface_name, iface_data|
    iface_data['addresses'].select{ |address, address_data|
      ['inet', 'inet6'].include? address_data['family']
    }.keys.flatten
  }

  # we search for the line 'example.com IN A 1.2.3.4' (and match against the IP only)
  ips.flatten.each do |local_ip|
    describe command('dig example.com @' + local_ip) do
      its(:stdout) { should match /example\.com\..*\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}/ }
    end
  end
end
