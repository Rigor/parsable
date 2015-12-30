require 'spec_helper'

describe Parsable::UriHelper do

  subject { described_class.new(URI.parse("http://httpbin.org/get?unsecure2=notsecure2&secure_api_key=flkdsjflksjfejifwf&unsecure=notsecure&")) }

  describe '#exploded_query' do
    it "is a hash representation of all query params" do
      expected = {"unsecure2"=>"notsecure2", "secure_api_key" => "flkdsjflksjfejifwf", "unsecure" => "notsecure" }
      expect(subject.exploded_query).to eql(expected)
    end

    context "no query" do
      subject { described_class.new(URI.parse("http://httpbin.org/get")) }
      it "is empty" do
        expect(subject.exploded_query).to eql({})
      end
    end
  end

  describe '#query_hash' do
    it "does not inlcude sensitve key" do
      expect(subject.query_hash.keys).to_not include("secure_api_key")
    end

    it "includes nonsecure param" do
      expect(subject.query_hash.keys).to include("unsecure")
    end
  end

  describe '#query' do
    it "is joined by &s" do
      expect(subject.query).to eql("unsecure2=notsecure2&unsecure=notsecure")
    end
  end

  describe '#secrets' do
    it "is a hash" do
      expect(subject.secrets).to be_kind_of(Hash)
    end

    it "has secret keys" do
      expect(subject.secrets.keys).to include("secure_api_key")
    end

    it 'does not have non secrets' do
      expect(subject.secrets.keys).to_not include("unsecure", "unsecure2")
    end
  end

end
