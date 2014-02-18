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

      context 'no function method' do
        before :each do
          @parsed = Parsable::Parser.new(:string => %(my+{{location.name}}@email.com)).parse.first
        end
        it "parses object name" do
          expect(@parsed[:object]).to eql('location')
        end

        it "parses attribute" do
          expect(@parsed[:attribute]).to eql('name')
        end
      end

      context "function method" do
        it "parses function method" do
          string = %(my+{{url_safe(location.name)}}@email.com)
          parsed = Parsable::Parser.new(:string => string).parse.first
          expect(parsed[:function]).to eql('url_safe')
        end
      end
    end

    context 'when multiple variables' do
      before :each do
        @parsed = Parsable::Parser.new(:string => %(my+{{location.name}}@{{email.domain}}.com)).parse
      end

      it "returns multiple strings" do
        expect(@parsed.size).to eql(2)
      end

      context 'no function method' do
        it "parses object names" do
          expect(@parsed.first[:object]).to eql('location')
          expect(@parsed.last[:object]).to eql('email')
        end

        it "parses attributes" do
          expect(@parsed.first[:attribute]).to eql('name')
          expect(@parsed.last[:attribute]).to eql('domain')
        end
      end

      context "function method" do
        it "parses function methods" do
          string = %(my+{{url_safe(location.name)}}@{{email.domain}}.com)
          parsed = Parsable::Parser.new(:string => string).parse

          expect(parsed.first[:function]).to eql('url_safe')
          expect(parsed.last[:function]).to be_nil
        end
      end
    end
  end

end
