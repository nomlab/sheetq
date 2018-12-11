require 'google/apis/sheets_v4'
require 'googleauth'
require 'googleauth/stores/file_token_store'
require 'launchy'
require 'forwardable'

# Retry if rate-limit.
Google::Apis::RequestOptions.default.retries = 5

module Sheetq
  class GoogleClient
    class AuthorizationError < StandardError ; end

    extend Forwardable

    def_delegators :@client,
    :get_spreadsheet_values

    def initialize(client_id, client_secret, token_store_path, user, logger = nil)
      @client_id = client_id
      @client_secret = client_secret
      @token_store_path = token_store_path
      @user = user
      @client = Google::Apis::SheetsV4::SheetsService.new
      @client.client_options.application_name = 'sheetq'
      if logger
        @logger = logger
      else
        # quiet
        @logger = ::Logger.new($stderr)
        @logger.formatter = proc {|severity, datetime, progname, msg| ""}
      end
    end

    def auth_interactively
      credentials = begin
                      authorizer.auth_interactively(@user)
                    rescue
                      raise AuthorizationError.new
                    end
      @client.authorization = credentials
      @client.authorization
    end

    def auth
      unless credentials = authorizer.credentials(@user)
        raise AuthorizationError.new
      end
      @client.authorization = credentials
      @client.authorization.username = @user # for IMAP
    end

    def batch(options = nil)
      @client.batch(options) do |batch_client|
        begin
          Thread.current[:glima_api_batch] = batch_client
          yield self
        ensure
          Thread.current[:glima_api_batch] = nil
        end
      end
    end

    private

    def authorizer
      @authorizer ||= Clian::Authorizer.new(
        @client_id,
        @client_secret,
        Google::Apis::SheetsV4::AUTH_SPREADSHEETS_READONLY,
        @token_store_path
      )
    end

    def me
      'me'
    end

    def client
      Thread.current[:glima_api_batch] || @client
    end

  end # class SheetsClient
end # module Sheetq
