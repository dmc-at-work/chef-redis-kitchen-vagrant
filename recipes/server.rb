#
# Cookbook:: custom-redis
# Recipe:: server
#
# Copyright:: 2018, The Authors, All Rights Reserved.
include_recipe "custom-redis::default"

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