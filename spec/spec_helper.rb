require "chefspec"
require "chefspec/berkshelf"

# Require all our libraries
Dir.glob("libraries/*.rb").shuffle.each { |f| require File.expand_path(f) }

RSpec.configure do |config|
  config.color = true
  config.tty = true
  config.formatter = :documentation
  config.filter_run focus: true
  config.run_all_when_everything_filtered = true
end

ChefSpec::Coverage.start!
