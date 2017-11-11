require "net/http"

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

        def get(path, headers = nil)
          request("get", path, nil, headers)
        end

        def post(path, body = nil, headers = nil)
          request("post", path, body, headers)
        end

        def put(path, body = nil, headers = nil)
          request("put", path, body, headers)
        end

        def patch(path, body = nil, headers = nil)
          request("patch", path, body, headers)
        end

        def delete(path, headers = nil)
          request("delete", path, nil, headers)
        end

        def head(path, headers = nil)
          request("head", path, nil, headers)
        end

        private

        def request(method, path, body = nil, optional_headers = nil)
          response = Response.new(
            "".tap do |raw_response|
              http_client.start do |session|
                headers = {
                  "Authorization" => authorization(method, path, body,
                                                   optional_headers),
                  "Content-Type" => "application/json"
                }.merge(optional_headers ? optional_headers : {})
                raw_response = if /^get$|^delete$|^head$/ =~ method
                                 session.send(method, path, headers)
                               else
                                 session.send(method, path, body, headers)
                               end
              end
              break raw_response
            end
          )

          Error.new(response.body).tap do |error|
            error.raise_error if error.exist?
          end
          response
        end

        def http_client
          @http_client ||= Net::HTTP.new(uri.host, uri.port).tap do |http|
            http.use_ssl = !!ssl
          end
        end

        def protocol
          ssl ? "https" : "http"
        end

        def authorization(method, path, body = nil, headers = nil)
          Authority.new(
            client: self, method: method.upcase, protocol: protocol,
            host: host, path: path, body: body, headers: headers
          ).publish_authorization
        end

        def uri
          @uri ||= URI("#{protocol}://#{host}")
        end
      end
    end
  end
end
