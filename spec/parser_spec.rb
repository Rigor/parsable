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

  describe '#strings' do
    subject { parser.strings }

    context 'when there are variables' do
      let(:string) { 'This is a string.' }

      it 'returns an empty array' do
        expect(subject).to eq([])
      end
    end

    context 'when there is one variable' do
      context 'at the beginning of the string' do
        let(:string) { '{{some.variable}} end of string.' }

        it 'finds the variable' do
          expect(subject).to eq(['some.variable'])
        end
      end

      context 'in the middle of the string' do
        let(:string) { 'Beginning of string {{some.variable}} end of string.' }

        it 'finds the variable' do
          expect(subject).to eq(['some.variable'])
        end
      end

      context 'at the end of the string' do
        let(:string) { 'Beginning of string {{some.variable}}' }

        it 'finds the variable' do
          expect(subject).to eq(['some.variable'])
        end
      end
    end

    context 'when there are multiple variables' do
      let(:string) { '{{foo.bar}} {{foo.baz}}' }

      it 'returns an array of parsed strings' do
        expect(subject).to match_array(['foo.bar', 'foo.baz'])
      end
    end
  end
end
