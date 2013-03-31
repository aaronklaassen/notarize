require "notarize/version"

module Notarize

  module Helper
    protected

    def sorted_query_string(params, reject_sig = true)
      params = params.reject { |k, v| k.to_s == 'signature' } if reject_sig

      qs = params.keys.sort_by { |k,v| k.to_s }.collect do |key|
        "#{key}=#{params[key]}"
      end.join('&')
    end

    def generate_signature(params, salt)
      puts sorted_query_string(params) + salt
      Digest::SHA256.hexdigest(sorted_query_string(params) + salt)
    end
  end

  module Client
    include Notarize::Helper  

    protected

    def signed_url(path, params)
      "#{config[:host]}#{path}?#{sorted_query_string(params)}&signature=#{generate_signature(params, config[:private_key])}"
    end

    def send_request(path, params = nil)
      # TODO: the future may require non-GET requests
      response = HTTParty.get(signed_url(path, params))
      { body: JSON.parse(response.body), code: response.code }
    end

    def config
      raise NotImplementedError.new "Notarize config not implemented."
      # {
      #   host:        "example.com"
      #   public_key:  "username"
      #   private_key: "secret"
      # }
    end
  end

  module Server
    include Notarize::Helper

    protected

    def request_signature(request)
      params = request.get? ? request.env["rack.request.query_hash"] : request.env["rack.request.form_hash"]

      # TODO: config won't work here because it's got to be the private key of the client, not the server.
      generate_signature(params, config[:private_key])
    end

    # TODO: sig checking
    # find_api_user(username)
  end

end