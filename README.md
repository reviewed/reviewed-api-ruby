# Reviewed

A Ruby Gem for Accessing the Reviewed.com API

## Installation

Add this line to your application's Gemfile:

    gem 'reviewed'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install reviewed

## Usage

Create a client to use in your application and configure as needed:

    client = Reviewed::Client.new(
      api_key: '0A0A1010202030',                    # required
      base_uri: 'http://www.example.com/api/v1',    # defaults to localhost:3000
      request_params: { per_page: 1 }               # query params applied to every request
    )

Make a request via resources on your client:

    client.articles.all
    client.articles.find('123456')

    client.products.all
    client.products.find('123456')

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Added some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
