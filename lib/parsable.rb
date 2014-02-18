require "parsable/version"
require 'parsable/parser'

module Parsable
  
  def self.crunch args={}
    Parsable::Parser.new(args).crunch
  end

end
