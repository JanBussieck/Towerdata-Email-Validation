require 'bundler'
Bundler.require(:default)

require 'email_variants'
require 'rspec'
require 'vcr'
require 'webmock/rspec'


VCR.configure do |c|
  c.cassette_library_dir = 'spec/fixtures/cassettes'
  c.allow_http_connections_when_no_cassette = true
  c.hook_into :webmock
end