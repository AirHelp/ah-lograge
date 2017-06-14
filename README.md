# Ah::Lograge
Common initializer for Lograge across Airhelp Rails projects

## Usage
just install it. You can pass env variable `DISABLE_LOGRAGE` to disable it.

## Custom params filtering
add `config/initializers/lograge.rb` to your app with following:
```ruby
Ah::Lograge.filter_params do |params|
  params.delete("unwanted")
end
```

## Installation
Add this line to your application's Gemfile:

```ruby
gem 'ah-lograge'
```

And then execute:
```bash
$ bundle
```

## Contributing
Just create a PR & ping me.

## License
The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).