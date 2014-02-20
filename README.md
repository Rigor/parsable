# Parsable [![Code Climate](https://codeclimate.com/github/hcliu/parsable.png)](https://codeclimate.com/github/hcliu/parsable) [![Build Status](https://travis-ci.org/hcliu/parsable.png?branch=master)](https://travis-ci.org/hcliu/parsable)

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
context = Parsable::Context.new

context.system_store('email', 'name', 'Bert') # top level for pre-defined variables

Parsable.crunch(\
  :string => %(my+{{email.name}}@email.com), :context => context
)

#=> my+Bert@email.com
```

```ruby
context = Parsable::Context.new
context.custom_store('email', 'bert@company.com') # scoped to "custom" for user-entered variables

context.read('custom', 'email')
#=> 'bert@company.com'

Parsable.crunch(\
  :string => %({{custom.email}} is my email!), :context => context
)

#=> bert@company.com is my email!
```

### Pre-defined
```ruby
  Parsable.crunch(:string => "{{random.hex}} {{random.integer}}")
  # "6e53a6dbab3a8e9b0eb9d467463c8a46 1392849191"
  # note: {{random.integer}} is implemented by Time.now.to_i, so not really random at all.

  Parsable.crunch(:string => "{{date.today}} {{date.year}} {{time.now}}")
  # "2014-02-19 2014 2014-02-19 17:35:35 -0500"  
```

## Contributing

1. Fork it ( http://github.com/<my-github-username>/parsable/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
