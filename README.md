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

First set your Reviewed.com API key:

    Reviewed.api_key = 'my api key'

Now you should be able to query the service:

    site = Reviewed::Website.find('DCI')
    puts site.name

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Added some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
