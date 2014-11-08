require 'serverspec'

include Serverspec::Helper::Exec
include Serverspec::Helper::DetectOS

RSpec.configure do |c|
  c.before :all do
    c.os = backend(Serverspec::Commands::Base).check_os
  end
end

describe 'service pdns' do
  it 'should be enabled and running' do
    expect(service 'pdns').to be_running
    expect(service 'pdns').to be_enabled
  end

  it 'should listen to port 53' do
    expect(port 53).to be_listening.with# tcp
  end

  it 'should answer to DNS queries' do

    @cmd = "dig typo3.org @127.0.0.1"
    # we search for the line "typo3.org IN A 1.2.3.4" (and match against the IP only)
    expect(command @cmd).to return_stdout /typo3\.org\..*\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}/
  end
end