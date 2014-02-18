# Parsable

A basic implementation of replacing inline {{variables}} with values. Inspired by [Shopify's Liquid](https://github.com/Shopify/liquid)

## Installation

Add this line to your application's Gemfile:

    gem 'parsable'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install parsable

## Usage

```ruby
email = OpenStruct.new(:name => "Bert")

Parsable.crunch(\
  :string => %(my+{{email.name}}@email.com), 
  :context => {:email => email}
)

#=> my+Bert@email.com
```

You must pass in a context that has a key that matches used `{{variables}}`. The value of that key must respond to the attribute (`{{variable.attribute}}`) 

## Contributing

1. Fork it ( http://github.com/<my-github-username>/parsable/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
