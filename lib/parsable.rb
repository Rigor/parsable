require "parsable/version"
require 'parsable/parser'
require 'parsable/context'
require 'parsable/parsed_item'
require 'parsable/remote'

module Parsable

  def self.crunch args={}
    original      = args.fetch(:string).to_s
    parsed_parts  = Parsable::Parser.new(args).parse
    context       = args[:context] || Parsable::Context.new

    crunched = original.dup

    parsed_parts.each do |item|
      crunched.gsub!("{{#{item.original}}}", context.read(item.object, item.attribute).to_s)
    end

    crunched
  end

end
