require "parsable/version"
require 'parsable/parser'
require 'parsable/context'
require 'parsable/parsed_item'
require 'parsable/remote'
require 'parsable/uri_helper'

module Parsable

  def self.crunch args={}
    original      = args.fetch(:string).to_s
    parsed_parts  = Parsable::Parser.new(args).parse
    context       = args[:context] || Parsable::Context.new

    crunched = original.dup

    parsed_parts.each do |item|
      # Using the block form of this method here due to how backslashes are handled by gsub.
      # See https://stackoverflow.com/questions/1542214/weird-backslash-substitution-in-ruby
      # particularly the answer that reads:
      ##################################################################################################################
      # The problem is that when using sub (and gsub), without a block, ruby interprets special character sequences
      # in the replacement parameter.
      ##################################################################################################################
      crunched.gsub!("{{#{item.original}}}") { context.read(item.object, item.attribute).to_s }
    end

    crunched
  end

end
