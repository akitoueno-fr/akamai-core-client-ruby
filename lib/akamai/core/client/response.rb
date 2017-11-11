module Akamai
  module Core
    module Client
      class Response
        attr_reader :http_response
        def initialize(http_response)
          @http_response = http_response
        end

        def body
          @body ||= if http_response.body
            JSON.parse(http_response.body).tap do |parsed_body|
              result =
                if /^Array$/ =~ parsed_body.class.name
                  [].tap do |arr|
                    parsed_body.each do |data|
                      arr << transform_data(data)
                    end
                  end
                else
                  transform_data(parsed_body)
                end
                break result
            end
          end
        end

        def code
          http_response.code.to_i
        end

        def headers
          @headers ||=
            {}.tap do |hash|
              http_response.header.each do |k, v|
                hash[k] = v
              end
            end
        end

        private

        def body_object
          JSON.parse(http_response.body)
        end

        def transform_data(data)
          return data.with_indifferent_access if /Hash/ =~ data.class.name
          data
        end
      end
    end
  end
end
