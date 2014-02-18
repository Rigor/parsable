require 'spec_helper'

describe Parsable do

  describe '.crunch' do
    it "outputs string with crunched values" do
      location = OpenStruct.new(:name => "Here")

      output = Parsable.crunch(\
        :string => %(my+{{location.name}}@email.com), 
        :context => {:location => location}
      )

      expect(output).to eql(%(my+Here@email.com))
    end

    context "nil string" do
      it "does nothing" do
        location = OpenStruct.new(:name => "Here")

        output = Parsable.crunch(\
          :string => nil, 
          :context => {:location => location}
        )

        expect(output).to eql("")
      end
    end

    context "no replacements" do
      it "returns the original" do
        string = %(my@email.com)
        output = Parsable.crunch(\
          :string => string, 
          :context => {}
        )

        expect(output).to eql(string)
      end
    end

    context "method not defined" do
      it "replaces with empty" do
        location = OpenStruct.new(:name => "Here")

        output = Parsable.crunch(\
          :string => %(my+{{location.not_name}}@email.com), 
          :context => {:location => location}
        )

        expect(output).to eql(%(my+@email.com))
      end
    end

    context "no context key" do
      it "replaces with empty" do
        location = OpenStruct.new(:name => "Here")

        output = Parsable.crunch(\
          :string => %(my+{{wrong_key.name}}@email.com), 
          :context => {:location => location}
        )

        expect(output).to eql(%(my+@email.com))
      end
    end
  end

end
