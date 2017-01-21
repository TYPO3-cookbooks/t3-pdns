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

def load_current_resource
  @current_resource = Chef::Resource::T3PdnsZone.new(new_resource.name)

  @current_resource.name(new_resource.name)
  @current_resource.exists = ::File.file?("/etc/powerdns/zones/#{new_resource.name}.zone")
  @current_resource
end

# Returns the pdns_control reload command, depending on if
# we create a new zone or update an existing one.
def reload_command

  if @current_resource.exists
    log "Zone #{@new_resource.name} already exists. Doing reload."
    "pdns_control bind-reload-now #{@new_resource.name}"
  else
    log "New zone #{@new_resource.name}. Adding."
    "pdns_control bind-add-zone #{@new_resource.name} /etc/powerdns/zones/#{new_resource.name}.zone"
  end

end

action :create do

  service "pdns"

  execute "reload via pdns_control" do
    command reload_command
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
    notifies  :run, "ruby_block[add #{new_resource.name} to zone.conf file]"
    notifies  :run, "execute[reload via pdns_control]"
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

  ruby_block "add #{@new_resource.name} to zone.conf file" do
    block do
      fe = Chef::Util::FileEdit.new(node['pdns']['authoritative']['config']['bind_config'])
      fe.insert_line_if_no_match(/zone "#{new_resource.name}"/,
                                 ['zone "',new_resource.name, '" in { type master; file "/etc/powerdns/zones/', new_resource.name, '.zone"; };'].join)
      fe.write_file
    end
  end

end

action :delete do

  service "pdns"

  execute "pdns_control reload" do
    action :nothing
  end

  template "/etc/powerdns/zones/#{new_resource.name}.zone" do
    action :delete
    notifies :run, "execute[pdns_control reload]"
  end

  ruby_block "delete zone file inclusion" do
    block do
      fe = Chef::Util::FileEdit.new(node['pdns']['authoritative']['config']['bind_config'])
      fe.search_file_delete_line(/zone "#{new_resource.name}"/)
      fe.write_file
    end
  end

end
