if defined?(ChefSpec)

  [:create, :update].each do |action|
    self.class.send(:define_method, "#{action}_example_topic") do |resource|
      ChefSpec::Matchers::ResourceMatcher.new(:example_topic, action, resource)
    end
  end

end
