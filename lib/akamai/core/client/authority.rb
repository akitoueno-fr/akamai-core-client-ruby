require "openssl"
require "securerandom"

module Akamai
  module Core
    module Client
      class Authority
        attr_reader :params, :client 
        def initialize(params)
          @params = params.with_indifferent_access
          @client = @params[:client]
        end

        def publish_authorization
          authorization_seed + "signature=#{signature}"  
        end

        def signature
          @signature ||= Base64.strict_encode64(
            OpenSSL::HMAC.digest(OpenSSL::Digest.new("sha256"), encryption_key, encryption_seed)
          )
        end

        def authorization_seed
          "EG1-HMAC-SHA256 " + 
            [].tap do |arr|
              %w(client_token access_token).each do |k|
                arr << "#{k}=#{client.send(k)}"
              end
              %w(timestamp nonce).each do |k|
                arr << "#{k}=#{send(k)}"
              end
            end.join(";") + ";"
        end

        private

        def encryption_key
          Base64.strict_encode64(
            OpenSSL::HMAC.digest(OpenSSL::Digest.new("sha256"), client.client_secret, timestamp)
          )
        end

        def encryption_seed
          [].tap do |arr|
            %w(method protocol host path).each do |k|
              arr << params[k]
            end
            # Although Akamai's document tell us to use header informations in creating signature, "
            # Probably Akamai use header informations to authenticate api request #
            # For now I set blank. #
            arr << ""
            arr << body_hash
            arr << authorization_seed 
          end.join("\t")
        end

        def body_hash
          return "" unless "POST" == params[:method]
          Base64.strict_encode64(
            OpenSSL::Digest.new("sha256").digest(params[:body])
          )
        end

        def nonce
          @nonce ||=
            (params[:nonce] || SecureRandom.uuid)
        end

        def timestamp
          @timestamp ||=
            (params[:timestamp] || Time.now.utc.strftime("%Y%m%dT%H:%M:%S%z"))
        end

        def canonicalized_headers
          return "" unless params[:headers]
          sorted_headers = Hash[params[:headers].sort]
          [].tap do |arr|
            sorted_headers.each do |k, v|
              arr << (k.downcase + ":" + v.to_s.gsub(/\s{2,}/, " "))
            end
          end.join("\t")
        end
      end
    end
  end
end
