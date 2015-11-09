# Ahub
A gem to interact with the [Answer Hub API](docs.answerhubapiv2.apiary.io)

[![Build Status](https://travis-ci.org/abelmartin/ahub.svg?branch=master)](https://travis-ci.org/abelmartin/ahub)

[![Build Status](https://travis-ci.org/abelmartin/ahub.svg?branch=v0.1.13)](https://travis-ci.org/abelmartin/ahub)

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'ahub'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install ahub

## Usage

By default, this gem will use the answer hub default connection credentials (answerhub/answerhub).  You can override defaults by setting content in [a .env file like the example](https://github.com/abelmartin/ahub/blob/master/.env_example) and reference it like this for example:

```bash
AHUB_ENV_FILE=~/workspace/.ahub_env irb
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/abelmartin/ahub. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](contributor-covenant.org) code of conduct.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

