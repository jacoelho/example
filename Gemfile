source "https://rubygems.org"

gem "berkshelf"
# circular dependency
# gem 'berkshelf', '~> 4.0', '>= 4.0.1'

group :development do
  gem "chefspec"
  gem "test-kitchen"

  gem "kitchen-vagrant"
  gem "kitchen-docker"
  gem "guard"
  gem "guard-rspec", require: false
  gem "foodcritic"
  gem "rubocop"

  gem "pry"
  gem "pry-doc"
  gem "rb-readline"
  # Until listen supports Ruby 2.0 and 2.1
  gem "listen", "< 3.1.0"
end
