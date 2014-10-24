# encoding: UTF-8
require 'towerdata_email'
require 'httparty'

module TowerdataEmail
  class NotSupportedByProviderError < StandardError; end

  class Provider

    def lead_data(address)
      raise NotSupportedByProviderError, 'TowerdataEmail::Provider#validate_email'
    end
  end

  class TowerDataDefault < TowerdataEmail::Provider
    include HTTParty
    base_uri 'http://api10.towerdata.com'

    def initialize
    end

    #https://api10.towerdata.com/person?email=john%2Cdoe@mailinator&find=postal&demos=10&license=12345

    def lead_data(address)
      opts = {
          headers: TowerdataEmail.config.headers,
          query: {
              license: TowerdataEmail.config.token,
              correct: 'email',
              email: address,
          },
          timeout: TowerdataEmail.config.timeout
      }

      with_valid_response('/person', opts) do |response|
        TowerdataEmail::Response.new(response)
      end
    end

    def with_valid_response(url, opts, &block)
      response = self.class.get(url, opts)
      case response.code
        when 200
          # All good
        when 401, 403
          raise TokenInvalidError
        when 500
          raise UnknownServerError.new("Problem with request.  Response '#{response}'")
        else
          raise BadConnectionToAPIError.new("Unknown status error #{response.code}: #{response}")
      end
      yield response
    end

  end
end