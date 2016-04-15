require 'serverspec'

set :backend, :exec

describe 'service pdns' do
  it 'should be enabled and running' do
    expect(service 'pdns').to be_running
    expect(service 'pdns').to be_enabled
  end

  it 'should listen to port 53' do
    expect(port 53).to be_listening.with 'tcp'
  end

end

# we search for the line "example.com IN A 1.2.3.4" (and match against the IP only)
describe command("dig example.com @127.0.0.1") do
  its(:stdout) { should match /example\.com\..*\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}/ }
end
