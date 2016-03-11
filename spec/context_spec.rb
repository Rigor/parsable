require 'spec_helper'

describe Parsable::Context do
  let(:context) { Parsable::Context.new }

  describe '#new' do
    it "sets default variables" do
      expect(context.instance_variable_get('@variables').keys.size).to eql(5)
    end
  end

  describe '#custom_store' do
    it "stores custom variables in the custom object_key" do
      context.custom_store :email, "test@test.com"
      expect(context.instance_variable_get('@variables')[:custom].email).to eql("test@test.com")
    end
  end

  describe "#custom_purge" do
    it "sets the custom variable to nil in the cusom object_key" do
      context.custom_store :email, "test@test.com"
      context.custom_purge :email
      expect(context.instance_variable_get("@variables")[:custom].email).to be_nil
    end
  end

  describe '#system_store' do
    it "stores variables as a top level object_key" do
      context.system_store :test_object, 'test_attribute', 'test_value'
      expect(context.instance_variable_get('@variables')[:test_object].test_attribute).to eql("test_value")
    end
  end

  describe "#system_purge" do
    it "sets the custom variable to nil in the cusom object_key" do
      context.system_store :test_object, "test_attribute", "test_value"
      context.system_purge :test_object, "test_attribute"
      expect(context.instance_variable_get("@variables")[:test_object].test_attribute).to be_nil
    end
  end

  describe '#read' do
    context 'object_key exists' do
      it "gets value for object.attribute" do
        context.instance_variable_get('@variables')[:test_object] = OpenStruct.new(:fruit => 'bananas')
        expect(context.read('test_object', 'fruit')).to eql("bananas")
      end
    end

    context 'no object_key' do
      it "is nil" do
        expect(context.read('not_exists', 'fruit')).to be_nil
      end
    end
  end
end
