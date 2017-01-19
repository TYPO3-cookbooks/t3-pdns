control 'pdns-1' do
  title 'PowerDNS Setup'

  describe package('pdns-server') do
    it { should be_installed }
  end

  # this is pretty ugly.. but well..
  sleep 3

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

  # we search for the line "example.com IN A 1.2.3.4" (and match against the IP only)
  describe command('dig example.com @127.0.0.1') do
    its(:stdout) { should match /example\.com\..*\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}/ }
  end

end
