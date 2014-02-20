module Parsable
  class ParsedItem
    attr_accessor :original, :function, :object, :attribute

    def initialize args={}
      @original  = args[:original]
      @function  = args[:function]
      @object    = args[:object]
      @attribute = args[:attribute]
    end
  end
end
