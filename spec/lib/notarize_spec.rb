require 'spec_helper'

describe Notarize::Notary do

  # sha256 of sorted query string + private key, i.e. "first=james&last=kirk&second=tiberiussecret"
  let(:correct_sig) { "359b09130269290d17ed2606a5e8c6f53517054b03a1955d7028197a6f7f65f2" }
  let(:params) { { first: "james", second: "tiberius", last: "kirk", signature: "blahblahblah" } }
  let(:correct_sorted_params) { "first=james&last=kirk&second=tiberius" }
  let(:private_key) { "secret" }

  let(:client) { Notarize::Notary.new("http://example.com", nil, private_key) }

  context "excluding the signature" do
    it "should sort the params by key" do
      Notarize::Notary.sorted_query_string(params).should == correct_sorted_params
    end
  end

  context "including the signature" do
    it "should sort the params by key" do
       Notarize::Notary.sorted_query_string(params, false).should == "#{correct_sorted_params}&signature=#{params[:signature]}"
    end
  end

  it "should generate the correct signature" do
     Notarize::Notary.generate_signature(params, private_key).should == correct_sig
  end

  it "should generate the wrong signature with wrong params" do
     Notarize::Notary.generate_signature({ foo: "foo", bar: "bar" }, private_key).should_not == correct_sig
  end

  it "should generate the wrong signature with wrong private key" do
     Notarize::Notary.generate_signature(params, "guesswork").should_not == correct_sig
  end

  it "should generate a complete signed URL" do
    correct_url = "http://example.com/path/to/api/?#{correct_sorted_params}&signature=#{correct_sig}"
    client.signed_url("/path/to/api/", params).should == correct_url
  end

  it "should refuse invalid HTTP verbs" do
    expect { client.send_request('/path/', {}, :garbage) }.to raise_error(ArgumentError)
  end

  it "should validate a correct signature" do
    Notarize::Notary.matching_signature?(params.merge(signature: correct_sig), private_key)
  end

  it "should not validate an incorrect signature" do
    Notarize::Notary.matching_signature?(params, private_key)
  end

end