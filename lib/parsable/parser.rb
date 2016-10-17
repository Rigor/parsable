module Parsable
  class Parser

    REGEX = /\{{2}(\w*\.?\S[^\{\{]*?)\}{2}/

    attr_accessor :original_string, :strings

    def initialize args={}
      @original_string = args.fetch(:string).to_s
    end

    def parse
      strings.map do |string|
        object, attribute = capture(string)

        Parsable::ParsedItem.new(\
          :original  => string,
          :object    => object,
          :attribute => attribute
        )
      end
    end

    def strings
      @strings ||= original_string.to_s.scan(REGEX).flatten
    end

    private

    def capture string
      [capture_object(string), capture_attribute(string)]
    end

    def capture_object string
      string[/(\w*)\.?\S*/, 1]
    end

    def capture_attribute string
      string[/\w*\.?(\S*)/, 1]
    end

  end

end
