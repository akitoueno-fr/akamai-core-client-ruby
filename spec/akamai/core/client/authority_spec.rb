require "spec_helper"

RSpec.describe Akamai::Core::Client::Authority do
  let(:client_secret) { "XXXXXXXXXXXXXXXXXXXX" }
  let(:host) { "akab-xxxxx.luna.akamaiapis.net" }
  let(:client_token) { "akab-xxxxxxxxx" }
  let(:access_token) { "akab-xxxxxxxxx" }
  let(:timestamp) { "20171111T07:45:39+0000" }
  let(:path) { "/diagnostic-tools/v1/locations/" }
  let(:nonce) { "6305b6d1-8014-437b-a787-dc462c4d614e" }
  let(:client) {
    Akamai::Core::Client.new(
      host: host,
      client_token: client_token,
      access_token: access_token,
      client_secret: client_secret
    )
  }
  let(:path) { "/diagnostic-tools/v1/locations" }
  let(:params) do
    {
      client: client, method: "GET", protocol: "https",
      host: host, path: path, body: nil, headers: nil,
      timestamp: timestamp, nonce: nonce
    }
  end
  let(:authority) do
    described_class.new(
      params
    )
  end
  describe("#signature") do
    subject { authority.signature }
    context "Given get method" do
      it "get correct signature" do
        expect(subject).to eq("aHvarPZPxqPyMeXXNzniEv1z4UXymLkCCP/2s2PvXFQ=")
      end
    end
  end
end
