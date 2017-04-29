require "spec_helper"

RSpec.describe Akamai::Core::Client do
  it "has a version number" do
    expect(Akamai::Core::Client::VERSION).not_to be nil
  end
end
