module Parsable
  class ParsedItem
    attr_accessor :original, :object, :attribute

    def initialize args={}
      @original  = args[:original]
      @object    = args[:object]
      @attribute = args[:attribute]
    end
  end
end
