require 'securerandom'
require 'date'
require 'ostruct'

module Parsable
  class Context

    attr_accessor :variables

    def initialize args={}

      @variables = args.fetch(:variables, {
        :random   => OpenStruct.new(:hex => SecureRandom.hex, :integer => Time.now.to_i),
        :date     => OpenStruct.new(:today => Date.today.to_s, :year => Date.today.year.to_s),
        :time     => OpenStruct.new(:now => Time.now.to_s),
        :custom   => OpenStruct.new
      })

      @variables.store(:remote, Parsable::Remote.new)
      @variables.store(:sremote, Parsable::Remote.new(:secure => true))
    end

    def custom_store attribute, value
      store :custom, attribute, value
    end

    def system_store object_key, attribute, value
      store object_key, attribute, value
    end

    def read object_key, attribute
      object(object_key).send(attribute.to_sym)
    end

    private

    def object object_key
      variables[object_key.to_sym] ||= OpenStruct.new
    end

    def store object_key, attribute, value
      object(object_key).send("#{attribute}=".to_sym, value)
    end

  end
end
