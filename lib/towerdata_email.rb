require "towerdata_email/version"
require "towerdata_email/providers"
require "json"

module TowerdataEmail

    # Domain Language Errors
    class MustProvideTokenError < StandardError; end
    class TokenInvalidError < StandardError; end
    class BadAPIConnectionError < StandardError; end

    def initialize

    end

    # Configuration
    def self.config
      @config ||= TowerdataEmail::Config.new
    end

    def self.config=(new_config)
      @config = new_config
    end

    def self.configure
      yield config if block_given?
      raise MustProvideTokenError, "Your provider requires an API token" unless config.token
    end

    # defaults to Tower Data see providers.rb
    def self.provider
      @provider ||= TowerdataEmail::TowerDataDefault.new
    end

    def self.provider=(new_prov)
      @provider = new_prov
    end

    # Before every call check cache first, is just a hash of response objects that is not persisted
    # given provider validates email and returns it as TowerdataEmail::Response Object
    def self.lead_data(email)
      provider.lead_data(email)
    end

    def self.validate_email(email)
      response  = lead_data(email)
      response.email
    end

    def self.postal_data(email)
      if config.postal
        response  = lead_data(email)
        response.postal
      end
    end

    def self.demographics_data(email)
      response  = lead_data(email)
      response.demographics
    end

    module ConnectionData
      attr_accessor :ok, :status_code, :status_desc
      UNSUPPORTED_ATTR = ['domain_type', 'role', 'plus4']
      alias :ok? :ok

      def incorrect?
        !ok?
      end

      def time_out?
        status_code == 5
      end

      protected
      def set_attributes(atts)
        unless atts.nil?
          atts.each do |key, value|
            unless UNSUPPORTED_ATTR.include? key
              send(:"#{key}=", value)
            end
          end
        end
      end

    end

    # A wrapper to the response from an email search request
    class Response
      attr_accessor :email, :postal, :demographics

      def initialize(response)
        @email = Email.new(response['email'])
        @postal = Postal.new(response['found_postal'])
        @demographics = Demographics.new(response['demographics'])
      end
    end

    class Demographics

      include ConnectionData

      attr_accessor :age, :gender, :occupation, :children, :household_income, :marital_status, :home_owner_status, :velocity

      # Create a new TowerdataEmail::Postal
      #
      # Arguments:
      #   fields: ('postal' field of HTTParty::Response)
      def initialize(demographics_data)
        set_attributes demographics_data
      end

    end

    class Postal

      include ConnectionData

      attr_accessor :fname, :lname, :address1, :address2, :city, :state, :zip

      # Create a new TowerdataEmail::Postal
      #
      # Arguments:
      #   fields: ('postal' field of HTTParty::Response)
      def initialize(postal_data)
        set_attributes postal_data
      end

    end

    class Email

      include ConnectionData

      attr_accessor :validation_level, :address, :username, :domain, :corrections

      # Create a new TowerData::Email
      #
      # Arguments:
      #   fields: (HTTParty::Response)
      def initialize(email_data)
        set_attributes email_data
      end

    end

    class Config
      attr_accessor :token, :headers, :show_corrections, :auto_accept_corrections, :only_validate_on_change, :timeout

      # TowerdataEmail::Config must provide a valid API toke (set an environment variable to your credentials)
      # token = ENV["your_api_key"]
      # Arguments:
      #   token: (String)
      # headers: (Hash)
      def initialize(token = nil, timeout = 5, headers =  { 'Content-Type' => 'application/json' } )
        @token = token
        @headers = headers
        @show_corrections = true
        @auto_accept_corrections = false
        @only_validate_on_change = false
        @timeout = timeout
      end

    end
  # Your code goes here...
end
