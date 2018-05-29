# # encoding: utf-8

# Inspec test for recipe custom-redis::server

# The Inspec reference, with examples and extensive documentation, can be
# found at http://inspec.io/docs/reference/resources/

describe package('redis-server') do
  it { should be_installed }
end

describe port(6379) do
  it { should be_listening }
end