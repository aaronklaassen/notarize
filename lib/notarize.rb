require "notarize/version"

module Notarize

  class Notary

    def initialize(host, public_key, private_key)
      @host = host
      @public_key = public_key
      @private_key = private_key
    end

    def send_request(path, params = {}, method = :get)
      raise ArgumentError.new("Invalid HTTP verb #{method}") if ![:get, :post, :put, :delete].include?(method)

      params ||= {}
      params.merge!({ public_key: @public_key })
      response = HTTParty.send(method, signed_url(path, params))

      { body: JSON.parse(response.body), code: response.code }
    end

    def signed_url(path, params)
      sorted_params = Notarize::Notary.sorted_query_string(params)
      sig = Notarize::Notary.generate_signature(params, @private_key)
      "#{@host}#{path}?#{sorted_params}&signature=#{sig}"
    end

    class << self
      def generate_signature(params, salt)
        Digest::SHA256.hexdigest(Notarize::Notary.sorted_query_string(params) + salt)
      end

      def sorted_query_string(params, reject_sig = true)
        params = params.reject { |k, v| k.to_s == 'signature' } if reject_sig

        qs = params.keys.sort_by { |k,v| k.to_s }.collect do |key|
          "#{key}=#{params[key]}"
        end.join('&')
      end

      # For the service-side
      def matching_signature?(params, private_key)
        generate_signature(params, private_key) == (params[:signature] || params['signature'])
      end

    end

  end

end