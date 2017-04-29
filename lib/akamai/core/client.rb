require "active_support"
require "active_support/core_ext"

module Akamai
  module Core
    module Client
      autoload :VERSION, "akamai/core/client/version"
      autoload :Authority, "akamai/core/client/authority"
      autoload :Client, "akamai/core/client/client"
      autoload :Error, "akamai/core/client/error"
      autoload :Response, "akamai/core/client/response"

      class << self
        def new(host:, client_token:, access_token:, client_secret:, ssl: true)
          Client.new(
            host: host, client_token: client_token, access_token: access_token,
            client_secret: client_secret, ssl: ssl
          )
        end
      end
    end
  end
end
