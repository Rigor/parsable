module Parsable
  class Parser

    attr_accessor :object, :attribute, :function_method, 
                  :original_string, :strings, :context

    def initialize args={}
      @original_string = args.fetch(:string)
      @context         = args[:context]
      @strings         = all_captures(@original_string)
    end

    def parse
      strings.collect do |string|
        function, object, attribute = capture(string)

        { 
          :original  => string, :function  => function,
          :object    => object, :attribute => attribute,
          :lambda    => lambda {
            if context[object.to_sym].respond_to?(attribute.to_sym)
              context[object.to_sym].send(attribute.to_sym)
            end
          }
        }
      end
    end

    def crunch
      crunched = original_string.dup
      parse.each do |item|
        crunched.gsub!("{{#{item[:original]}}}", "#{item[:lambda].call}")
      end

      crunched
    end

    private

    def capture string
      [capture_function_method(string), capture_object(string), capture_attribute(string)]
    end

    def all_captures string
      string.to_s.scan(/\{\{(\w*\(?\w*\.?\w*\)?)\}\}/).flatten
    end

    def capture_function_method string
      match = string.match(/(.*)\(.*\)/)
      match[1] if match
    end

    def capture_attribute string
      object_attribute(string).last
    end

    def capture_object string
      object_attribute(string).first
    end

    def object_attribute string
      string.match(/(\w*\.\w*)/)[1].split('.')
    end

  end

end
