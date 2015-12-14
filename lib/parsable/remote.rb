require 'uri'
require 'curb'

module Parsable
  class Remote
    # uses the response from a remote location

    def initialize
    end

    def method_missing(method_sym, *arguments, &block)
      if uri = uri?(method_sym)
        get_response(uri)
      end
    end

    private

    def get_response uri
      0.upto(2) do |i|
        begin
          Curl::Easy.perform(uri.to_s) do |http|
            http.connect_timeout = 2
            http.on_success { |easy| @body = easy.body_str }
          end
        rescue Curl::Err::CurlError
        end

        break if @body
      end
      @body
    end

    def uri? string
      uri = URI.parse(string)
      if uri && uri.kind_of?(URI::HTTP)
        uri
      else
        false
      end
    rescue URI::InvalidURIError
      false
    end

  end
end
