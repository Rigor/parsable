require 'uri'
require 'curb'

module Parsable
  class Remote
    # uses the response from a remote location

    attr_accessor :secure

    def initialize options={}
      self.secure = options.fetch(:secure, false)
    end

    def method_missing(method_sym, *arguments, &block)
      if uri = uri?(method_sym)
        get_response(uri)
      end
    end

    private

    def perform url, headers={}
      begin
        Curl::Easy.perform(url) do |http|
          headers.each { |header, value| http.headers[header] = value }
          http.connect_timeout = 2
          http.on_success { |easy| @body = easy.body_str }
        end
      rescue Curl::Err::CurlError
      end
    end

    def get_response uri
      transformer = Parsable::UriHelper.new(uri)
      url = transformer.to_s
      headers = transformer.secrets

      0.upto(2) do |i|
        perform(url, headers)

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
