require 'spec_helper'


describe Notarize::Helper do

  class ApiClient
    include Notarize::Client
  end

  # sha256 of sorted query string + private key, i.e. "first=james&last=kirk&second=tiberiussecret"
  let(:correct_sig) { "359b09130269290d17ed2606a5e8c6f53517054b03a1955d7028197a6f7f65f2" }
  let(:params) { { first: "james", second: "tiberius", last: "kirk", signature: "blahblahblah" } }
  let(:correct_sorted_params) { "first=james&last=kirk&second=tiberius" }
  let(:private_key) { "secret" }

  let(:client) { ApiClient.new } 

  before(:each) do
    Notarize::Client.send(:public, *Notarize::Client.protected_instance_methods)  
  end

  context "excluding the signature" do
    it "should sort the params by key" do
      client.sorted_query_string(params).should == correct_sorted_params
    end
  end

  context "including the signature" do
    it "should sort the params by key" do
      client.sorted_query_string(params, false).should == "#{correct_sorted_params}&signature=#{params[:signature]}"
    end
  end

  it "should generate the correct signature" do
    client.generate_signature(params, private_key).should == correct_sig
  end

end