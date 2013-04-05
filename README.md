## Notarize

For basic json web services that don't want just anyone to have access. Generates signature hashes for http requests.

## Installation

Add this to your Gemfile:

    gem 'notarize'

And run:

    $ bundle

Or install it with:

    $ gem install notarize


## Usage

## As the client

    include Notarize::Client

Implement a #config method that returns a hash with :host, :public_key, and :private_key values for the service you're using. Then just call #send_request with the path and a parameter list.

    def config
      { host: "http://www.example-service.com/", public_key: "yourname", private_key: "secret" }
    end

    ...

    send_request("/example/path/42/", { foo: "Foo", bar: "Bar" }, :get)

send_request returns a hash with two values. :body with the parsed json response, and :code with the HTTP status code.

## As the server

Notarize provides a generate_signature helper method that takes a hash of the incoming params, and the private key of the client making the request. Result should match the value in the incoming 'signature' parameter. For example, in a before_filter:

    include Notarize::Helper
    
    before_filter :authenticate_request!
    ...

    def authenticate_request!
      client = ApiClient.where(public_key: params[:public_key])

      if generate_signature(params, client.private_key) == params[:signature]
        # It's ok!
      else
        # Refuse!
      end
    end

Notarize doesn't manage your list of authorized clients for you.

## Parties Responsible

Author: Aaron Klaassen (aaron@outerspacehero.com)