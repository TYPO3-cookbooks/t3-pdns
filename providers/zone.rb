#
# Cookbook Name:: t3-pdns
# Provider:: zone
#
# Copyright 2014, TYPO3 Association
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

def whyrun_supported?
  true
end

use_inline_resources

action :create do

  service "pdns"

  execute "pdns_control notify #{new_resource.name}" do
    action :nothing
  end

  directory "#{Chef::Config[:file_cache_path]}/powerdns-zones/"

  serial =  Time.new.strftime("%Y%m%d%H%M%S")

  template "/etc/powerdns/zones/#{new_resource.name}.zone" do
    source    "#{Chef::Config[:file_cache_path]}/powerdns-zones/#{new_resource.name}.zone.erb"
    local     true
    cookbook  new_resource.cookbook
    mode      0644
    action    :create
    notifies  :restart, resources(:service => "pdns")
    variables(
      :serial => serial,
      :serial_modulo => serial.to_i % 2 ** 32 # modulo 2^32
    )
    action :nothing
  end

  template "#{Chef::Config[:file_cache_path]}/powerdns-zones/#{new_resource.name}.zone.erb" do
    source    new_resource.source
    cookbook  new_resource.cookbook
    mode      0644
    action    :create
    notifies  :restart, "service[pdns]"
    notifies  :run, "execute[pdns_control notify #{new_resource.name}]"
    variables(
      :domain => new_resource.name,
      :soa => new_resource.soa,
      :contact => new_resource.contact.gsub(/@/, '.'),
      :global_ttl => new_resource.global_ttl,
      :nameserver => new_resource.nameserver,
      :mail_exchange => new_resource.mail_exchange,
      :records => new_resource.records,
    )
    notifies :create, resources(:template => "/etc/powerdns/zones/#{new_resource.name}.zone"), :immediately
  end

  ruby_block "delete zone file inclusion" do
    block do
      fe = Chef::Util::FileEdit.new("/etc/powerdns/zones/zones.conf")
      fe.insert_line_if_no_match(/zone "#{new_resource.name}"/,
                                 ['zone "',new_resource.name, '" in { type master; file "/etc/powerdns/zones/', new_resource.name, '.zone"; };'].join)
      fe.write_file
    end
  end

end

action :delete do

  service "pdns"

  template "/etc/powerdns/zones/#{new_resource.name}.zone" do
    action :delete
    notifies :restart, resources(:service => "pdns")
  end

  ruby_block "delete zone file inclusion" do
    block do
      fe = Chef::Util::FileEdit.new("/etc/powerdns/zones/zones.conf")
      fe.search_file_delete_line(/zone "#{new_resource.name}"/)
      fe.write_file
    end
  end

end
