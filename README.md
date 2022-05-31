# Empathy::Json

A gem to serialize and manipulate [EmpJson](https://empathy.tools/specifications/emp-json) slices.

## Installation

Install the gem and add to the application's Gemfile by executing:

    $ bundle add emp_json_rb

If bundler is not being used to manage dependencies, install the gem by executing:

    $ gem install emp_json_rb

## Usage

The module was built to work with [rdf-serializers](https://github.com/ontola/rdf-serializers), and uses serializer descriptions from that gem.

Include the `Empathy::Json::Slices` module and call `emp_json_hash(resource)` for a hash representation or `render_emp_json(resource)` for a stringified version.

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake test` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and the created tag, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/empathy-tools/emp_json_rb. Contributors are expected to adhere to the [code of conduct](https://github.com/empathy-tools/emp_json_rb/blob/main/CODE_OF_CONDUCT.md).

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
