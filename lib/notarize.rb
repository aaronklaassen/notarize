require "notarize/version"

module Notarize

  module Helper
    protected

    def sorted_query_string(params, reject_sig = true)
      params = params.reject { |k, v| k == 'signature' } if reject_sig

      qs = params.keys.sort_by { |k,v| k.to_s }.collect do |key|
        "#{key}=#{params[key]}"
      end.join('&')
    end

    def generate_signature(params, salt)
      Digest::SHA256.hexdigest(sorted_query_string(params) + salt)
    end
  end

  module Client
    protected

    def signed_url(path, params)
      "#{config[:host]}#{path}?#{sorted_query_string(params)}&signature=#{generate_signature(params, config[:private_key])}"
    end

    def send_request(path, params = nil)
      # TODO: the future may require non-GET requests
      response = HTTParty.get(signed_url(path, params))
      { body: JSON.parse(response.body), code: response.code }
    end
  end

  module Server
    protected

    def request_signature(request)
      params = request.get? ? request.env["rack.request.query_hash"] : request.env["rack.request.form_hash"]
      generate_signature(params, self.private_key) # TODO: where will this key be stored?
    end
  end

end