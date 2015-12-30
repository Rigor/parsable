require 'spec_helper'
require 'json'

describe Parsable::Remote do

  subject { described_class.new }

  describe '.method_missing', :vcr => true do
    context "url" do
      it "returns the body" do
        expect(subject.send("http://httpstat.us/200")).to eql "200 OK"
      end

      context "with query params" do
        it "uses them in the request" do
          query = {"args" => {"query1" => "q1", "query2" => "q2"}}
          expect(JSON.parse(subject.send("http://httpbin.org/get?query1=q1&query2=q2"))).to include(query)
        end
        context "with secure request" do

          subject { described_class.new(:secure => true) }

          it "moves sensitive query params into headers" do
            query = {"unsecure" => "notsecure"}
            headers = {"api_key" => "flkdsjflksjfejifwf"}
            body_hash = JSON.parse(subject.send("http://httpbin.org/get?api_key=flkdsjflksjfejifwf&unsecure=notsecure"))
            expect(body_hash["args"]).to eql(query)
            expect(body_hash["headers"]).to include("Api-Key" => "flkdsjflksjfejifwf")
          end
        end
      end

      context "cant connect" do
        context "bad response code" do
          it "returns nil" do
            expect(subject.send("http://httpstat.us/500")).to be_nil
          end
        end

        context "bad dns" do
          it "returns nil" do
            expect(subject.send("http://blahblahblahblahblahdoesntexist.com")).to be_nil
          end
        end

        context "blackhole" do
          it "returns nil" do
            expect(subject.send("http://blackhole.webpagetest.org")).to be_nil
          end
        end
      end
    end

    context "not a url" do
      it "returns nil" do
        expect(subject.send("notaurl")).to be_nil
      end
    end
  end


end
