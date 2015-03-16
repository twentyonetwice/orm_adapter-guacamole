# OrmAdapter::Guacamole

This gem provides a simple entry to [ArangoDB] via [guacamole gem]. Its further use may be e.g. to use Devise

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'orm_adapter-guacamole'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install orm_adapter-guacamole

## Usage

Detailed informations about usage are available at [Ian Whites orm_adapter page]

NOTICE: Relations between models will not work until now.

## Development

To run the specs, you can start from the last known good set of gem dependencies in Gemfile.lock.development:

    git clone http://github.com/klausinho/orm_adapter-guacamole
    cd orm_adapter-guacamole
    bundle install
    bundle exec rake spec

There are 4 pending specs. They are all related to model relations.
All other tests were green and should be kept green :)

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request

[Ian Whites orm_adapter page]: https://github.com/ianwhite/orm_adapter
[ArangoDB]: https://www.arangodb.com/
[guacamole gem]: https://github.com/triAGENS/guacamole

## Copyright and License

Copyright 2015 by Klaus Humme and Ian White. See LICENSE.txt for further license informations.
