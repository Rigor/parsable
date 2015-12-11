require 'spec_helper'

describe Parsable::Parser do

  describe '#parse' do

    context "when no variables" do
      it "returns empty" do
        parsed = Parsable::Parser.new(:string => "novariables").parse
        expect(parsed).to be_empty
      end
    end

    context "nil string" do
      it "returns empty" do
        parsed = Parsable::Parser.new(:string => nil).parse
        expect(parsed).to be_empty
      end
    end

    context 'when one variable' do
      before :each do
        @parsed = Parsable::Parser.new(:string => %(my+{{location.name}}@email.com)).parse.first
      end
      it "parses object name" do
        expect(@parsed.object).to eql('location')
      end

      it "parses attribute" do
        expect(@parsed.attribute).to eql('name')
      end
    end

    context 'when multiple variables' do
      before :each do
        @parsed = Parsable::Parser.new(:string => %(my+{{location.name}}@{{email.domain}}.com)).parse
      end

      it "returns multiple strings" do
        expect(@parsed.size).to eql(2)
      end

      it "parses object names" do
        expect(@parsed.first.object).to eql('location')
        expect(@parsed.last.object).to eql('email')
      end

      it "parses attributes" do
        expect(@parsed.first.attribute).to eql('name')
        expect(@parsed.last.attribute).to eql('domain')
      end
    end

    context 'when remote object' do
      subject { Parsable::Parser.new(:string => %({{remote.http://google.com?query1=q1&query2=q2}}@email.com)).parse.first }

      it "parses object name" do
        expect(subject.object).to eql('remote')
      end

      it "parses attribute" do
        expect(subject.attribute).to eql('http://google.com?query1=q1&query2=q2')
      end
    end
  end

end
