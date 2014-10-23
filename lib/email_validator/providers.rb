# encoding: UTF-8
require 'tower_data'
require 'httparty'

module EmailValidator
  class NotSupportedByProviderError < StandardError; end

  class Provider
    def validate_email(address)
      raise NotSupportedByProviderError, 'EmailValidator::Provider#validate_email'
    end
  end

  class TowerDataDefault < EmailValidator::Provider
    include HTTParty
    base_uri 'http://api10.towerdata.com'

    def initialize
    end

    def validate_email(address)
      opts = {
          headers: EmailValidator.config.headers,
          query: {
              license: EmailValidator.config.token,
              correct: 'email',
              email: address
          },
          timeout: EmailValidator.config.timeout
      }

      with_valid_response('/person', opts) do |response|
        EmailValidator::Email.new(response)
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