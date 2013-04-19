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

Just instantiate a Notary object with your service config and call #send_request with the path and a parameter list.

    notary = Notarize::Notary.new("http://www.example.com", "public_key", "private_key")    
    notary.send_request("/example/path/42/", { foo: "Foo", bar: "Bar" })

Optionally you can also pass in an alternate HTTP verb for non-GET requests. Accepted values are :get (the default), :post, :put, and :delete.

    response = notary.send_request("/example/path/42/", { foo: "Foo", bar: "Bar" }, :post)

send_request returns a hash with two values. :body with the parsed json response, and :code with the HTTP status code.

## As the server

Notarize provides a matching_signature? class method that takes a hash of the incoming params, and the private key of the client making the request. The result is checked against params[:signature].

    before_filter :authenticate_request!
    ...

    def authenticate_request!
      client = ApiClient.where(public_key: params[:public_key]).first # Or however your app works.

      if Notarize::Notary.matching_signature?(params, client.private_key)
        # It's ok!
      else
        # Get outta town!
      end
    end

This ApiClient object is just an example; Notarize doesn't manage your list of authorized clients for you.

## Parties Responsible

Aaron Klaassen
aaron@outerspacehero.com
http://www.outerspacehero.com/