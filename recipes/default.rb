#
# Cookbook:: custom-redis
# Recipe:: default
#
# Copyright:: 2018, The Authors, All Rights Reserved.

apt_update 'daily' do
  frequency 86_400
  action :periodic
end

# Adds the repository redis
apt_repository node["redis"]["apt_repository"] do
  # The base of the Debian distribution.
  uri node["redis"]["apt_uri"]
  
  # Usually a distribution’s codename, such as trusty, xenial or bionic. Default value: the codename of the node’s distro.
  distribution node["redis"]["apt_distribution"]
  
  # Package groupings, such as ‘main’ and ‘stable’. Default value: empty array.
  components node["redis"]["apt_components"]
  
  # The GPG keyserver where the key for the repo should be retrieved. Default value: “keyserver.ubuntu.com”.
  keyserver node["redis"]["apt_keyserver"]
  
  # If a keyserver is provided, this is assumed to be the fingerprint; otherwise it can be either the URI of GPG key for the repo, or a cookbook_file. Default value: empty array.
  key node["redis"]["apt_key"]
end

package "redis-server" do
  action node["redis"]["auto_upgrade"] ? :upgrade : :install
end

directory node["redis"]["dir"] do
  # A string or ID that identifies the group owner by user name, including fully qualified user names such as domain\user or user@domain
  owner "redis"

  # A string or ID that identifies the group owner by group name, including fully qualified group names such as domain\group or group@domain
  group "redis"

  # Directory permission
  mode "0750"

  # Create parent directories recursively
  recursive true
end

# A service resource block manages the state of a service
service "redis-server" do
  # specifies that this service supports restart
  supports restart: true

  # :enable - enanbles the service at boot
  # :start - starts the service
  action [:enable, :start]
end

# Creates the /etc/redis/redis.conf file from redis.conf.erb in the templates
template "/etc/redis/redis.conf" do
  # the source template
  source "redis.conf.erb"

  # changes the owner of the file to root
  owner  "root"

  # changes the group of the file to root
  group  "root"

  # changes the file permission 
  mode   "0644"

  # notifies the service to restart
  notifies :restart, "service[redis-server]"
end

# 
template "/etc/default/redis-server" do
  #
  source "default_redis-server.erb"
  
  #
  owner  "root"
  
  #
  group  "root"
  
  #
  mode   "0644"
  
  #
  notifies :restart, "service[redis-server]"
end
