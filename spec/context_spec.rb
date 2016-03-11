require 'spec_helper'

describe Parsable::Context do

  let(:context) { Parsable::Context.new }

  describe '#new' do
    it "sets default variables" do
      keys = %i(random date time custom remote sremote)
      expect(context.instance_variable_get('@variables').keys).to match_array(keys)
    end
  end

  describe '#custom_store' do
    it "stores custom variables in the custom object_key" do
      context.custom_store :email, "test@test.com"
      expect(context.instance_variable_get('@variables')[:custom].email).to eql("test@test.com")
    end
  end

  describe '#system_store' do
    it "stores variables as a top level object_key" do
      context.system_store :test_object, 'test_attribute', 'test_value'
      expect(context.instance_variable_get('@variables')[:test_object].test_attribute).to eql("test_value")
    end
  end

  describe '#purge' do
    subject { context.purge :test_object }

    context 'when the object_key exists' do
      before { context.system_store :test_object, 'test_attribute', 'test_value' }

      it 'delete the object_key' do
        subject
        expect(context.instance_variable_get('@variables').keys).not_to include(:test_object)
      end

      it 'returns the value' do
        subject
        expect(context.instance_variable_get('@variables').keys).not_to include(:test_object)
      end
    end

    context 'when the object_key does NOT exist' do
      it 'does not return the object key' do
        expect { subject }.not_to change { context.instance_variable_get('@variables').keys }
      end

      it 'returns nil' do
        expect(subject).to be_nil
      end
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
