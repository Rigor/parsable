require "parsable/version"
require 'parsable/parser'
require 'parsable/context'

module Parsable
  
  def self.crunch args={}
    original      = args.fetch(:string).to_s
    parsed_parts  = Parsable::Parser.new(args).parse

    crunched = original.dup

    parsed_parts.each do |item|
      crunched.gsub!("{{#{item[:original]}}}", "#{item[:lambda].call}")
    end

    crunched
  end

end
