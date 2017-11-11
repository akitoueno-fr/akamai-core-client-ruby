# Akamai::Core::Client::Ruby
This library provides fundamental functions to call Akamai API.  
Using this library, you can easily request HTTP methods with akamai signature.  

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'akamai-core-client-ruby'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install akamai-core-client-ruby

## Usage
You can initialize this cient following code.  
```ruby
require "akamai/core/client"
client = Akamai::Core::Client.new(
  client_secret: "xxxxxxx_secret",
  host: "akab-host.luna.akamaiapis.net",
  access_token: "akab-xxxxxxxxx",
  client_token: "akab-xxxxxxxxx"
)
```

### HTTP GET
```ruby
response = client.get(
  "/papi/v0/contracts/"
)
response.code # 200
response.headers # {"server"=>"Apache-Coyote/1.1", "content-language"=>"en-US", "etag"=>"\"xxxxxxxxxe440d81b1a171ca579b2597587\"", "vary"=>"Accept-Encoding", "content-type"=>"text/plain", "date"=>"Sat, 11 Nov 2017 13:39:20 GMT", "connection"=>"keep-alive"}
response.body["contracts"]["items"].each do |contract|
  contract # {"contractId"=>"ctr_M-XXXXXX", "contractTypeName"=>"DIRECT_CUSTOMER"}
end
```

### HTTP POST
```ruby
body = {
  "cpcodeName" => "SME WAA",
  "productId" => "prd_Web_App_Accel"
}
client.post("/papi/v1/cpcodes?contractId=ctr_1–1TJZFW&groupId=grp_15166", body.to_json)
```

### HTTP PUT
```ruby
body = {
  "ruleFormat" => "v2015-08-08",
  "usePrefixes" => "true"
}
client.put("/papi/v1/client-settings", body.to_json)
```

### HTTP HEAD
```ruby
client.head("/papi/v1/properties/prp_175780/versions/3/rules?contractId=ctr_1–1TJZFW&groupId=grp_15166&validateRules=true&validateMode=fast&dryRun=true")
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/akamai-core-client-ruby. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

