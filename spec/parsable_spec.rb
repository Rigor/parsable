require 'spec_helper'

describe Parsable do

  let(:context) { Parsable::Context.new }

  before :each do
    context.system_store 'location', 'name', 'Here'
    context.system_store 'some', 'backslashes', %Q(\\\\)
  end

  describe '.crunch' do
    it "outputs string with crunched values" do

      output = Parsable.crunch(\
        :string => %(my+{{location.name}}@email.com),
        :context => context
      )

      expect(output).to eql(%(my+Here@email.com))
    end

    context "nil string" do
      it "does nothing" do

        output = Parsable.crunch(\
          :string => nil,
          :context => context
        )

        expect(output).to eql("")
      end
    end

    context "no replacements" do
      it "returns the original" do
        string = %(my@email.com)
        output = Parsable.crunch(\
          :string => string,
          :context => context
        )

        expect(output).to eql(string)
      end
    end

    context "same replacement" do
      it "replaces both strings" do
        string = %(my{{location.name}}@email.com{{location.name}})
        output = Parsable.crunch(\
          :string => string,
          :context => context
        )

        expect(output).to eql(%(myHere@email.comHere))
      end
    end

    context 'with backslashes' do
      it 'does not interpolate backslashes in the replacement' do
        string = '{{some.backslashes}}'
        output = Parsable.crunch(\
          :string => string,
          :context => context
        )
        expect(output).to eql(%Q(\\\\))
      end
    end

    context "method not defined" do
      it "replaces with empty" do

        output = Parsable.crunch(\
          :string => %(my+{{location.not_name}}@email.com),
          :context => context
        )

        expect(output).to eql(%(my+@email.com))
      end
    end

    context "no context key" do
      it "replaces with empty" do

        output = Parsable.crunch(\
          :string => %(my+{{wrong_key.name}}@email.com),
          :context => context
        )

        expect(output).to eql(%(my+@email.com))
      end
    end
  end

end
