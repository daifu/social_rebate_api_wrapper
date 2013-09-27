# SocialRebate

This is a gem for social rebate api, it can verify, cancel, and get from social rebate using their api.

## Installation

Add this line to your application's Gemfile:

    gem 'social_rebate'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install social_rebate

## Usage

# Set up
Set env variable for SR_API_KEY, SR_API_SECRET, and SR_STORE_KEY

# Init social rebate
SocialRebate.init({:order_email => 'customer@email.com', :total_purchase => '1000', :order_id => 23232})

# Verfiy social rebate
SocialRebate.verify('order token', {:order_email => 'customer@email.com', :total_purchase => '1000', :order_id => 23232})

# Cancel social rebate
SocialRebate.cancel('order token', {:order_email => 'customer@email.com', :total_purchase => '1000', :order_id => 23232})

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
