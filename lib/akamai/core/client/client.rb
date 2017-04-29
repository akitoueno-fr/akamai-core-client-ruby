require "faraday"

module Akamai
  module Core
    module Client
      class Client
        attr_reader :host, :client_token, :access_token, :client_secret, :ssl
        def initialize(host:, client_token:, access_token:, client_secret:, ssl: true)
          @host = host
          @client_token = client_token
          @access_token = access_token
          @client_secret = client_secret
          @ssl = ssl
        end

        def get(path)
          request("get", path)
        end

        def post(path, body = nil)
          request("post", path, body)
        end

        private

        def request(method, path, body = nil)
          response_body = Response.new(
            http_client.send(method) do |request|
              request.url path
              request.headers["Content-Type"] = "application/json"
              request.headers["Authorization"] = authorization(method, path, body)
            end
          ).body

          Error.new(response_body).tap do |error|
            error.raise_error if error.exist?
          end
          response_body
        end

        def http_client
          @http_client ||= Faraday.new("#{protocol}://#{host}")
        end

        def protocol
          ssl ? "https" : "http"
        end

        def authorization(method, path, body = nil)
          Authority.new(
            client: self, method: method.upcase, protocol: protocol,
            host: host, path: path, body: body
          ).publish_authorization
        end
      end
    end
  end
end
