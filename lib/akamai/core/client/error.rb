module Akamai
  module Core
    module Client
      class Error
        AkamaiError = Class.new(StandardError)
        attr_reader :body
        def initialize(body)
          @body = /Array/ =~ body.class.name ? body[0] : body
        end

        def exist?
          !!message
        end

        def raise_error
          raise(AkamaiError, message) if exist?
        end

        private

        def message
          @message ||=
            case body.class.name
            when /Hash/
              if body[:errorString]
                body[:errorString]
              elsif body[:status] && /^4\d{2}|^5\d{2}/ =~ body[:status].to_s
                body[:detail]
              end
            end
        end
      end
    end
  end
end
