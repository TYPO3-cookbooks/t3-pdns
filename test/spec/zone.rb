require 'spec_helper'

# lwrp default use cookbook name as namespace, here assume the cookbook is `workstation`
describe 'github resource' do
  let(:github_resource) { Chef::Resource::WorkstationGithub.new('user_key') }
  it 'creates new resource with name' do
    expect(github_resource.name).to eq('user_key')
  end
end