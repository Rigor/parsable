require 'spec_helper'

describe Parsable::Parser do
  let(:parser) { described_class.new(:string => string) }

  describe '#parse' do
    subject { parser.parse }
    let(:first) { subject.first }

    context "when no variables" do
      let(:string) { "novariables" }
      it "returns empty" do
        expect(subject).to be_empty
      end
    end

    context "nil string" do
      let(:string) { nil }
      it "returns empty" do
        expect(subject).to be_empty
      end
    end

    context 'when one variable' do
      let(:string) { %(my+{{location.name}}@email.com) } 
      
      it "parses object name" do
        expect(first.object).to eql('location')
      end

      it "parses attribute" do
        expect(first.attribute).to eql('name')
      end
    end

    context 'when multiple variables' do
      let(:string) { %(my+{{location.name}}@{{email.domain}}.com) }

      it "returns multiple strings" do
        expect(subject.size).to eql(2)
      end

      it "parses object names" do
        expect(subject.first.object).to eql('location')
        expect(subject.last.object).to eql('email')
      end

      it "parses attributes" do
        expect(subject.first.attribute).to eql('name')
        expect(subject.last.attribute).to eql('domain')
      end
    end

    context 'when remote object' do
      let(:string) { %({{remote.http://google.com?query1=q1&query2=q2}}@email.com) }  
      it "parses object name" do
        expect(first.object).to eql('remote')
      end

      it "parses attribute" do
        expect(first.attribute).to eql('http://google.com?query1=q1&query2=q2')
      end
    end

    context 'when the match has the potential to greedy match' do
      let(:string) { %({{foo.bar}}some other text}}) }

      it 'performs a non-greedy match' do
        expect(first.attribute).to eq('bar')
      end
    end
  end
end
