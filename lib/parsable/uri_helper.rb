module Parsable
  class UriHelper

    def initialize uri
      @uri = uri
    end

    def exploded_query
      @query ||= original_query.split("&").each_with_object({}) do |query, hash|
        name, value = query.split("=")
        hash.store(name, value) if name && value
      end
    end

    def query
      query_hash.each_with_object([]) { |(key, value), array| array.push("#{key}=#{value}") }.join("&")
    end

    def query_hash
      exploded_query.reject { |key, value| scrub_param?(key) }
    end

    def secrets
      exploded_query.select { |key, value| scrub_param?(key) }
    end

    def to_s
      uri = @uri.dup
      uri.query = query
      uri.to_s
    end

    private

    def original_query
      @uri.query.to_s
    end

    def scrub_param? param_name
      !!(param_name =~ /(key|token)/)
    end
  end
end
