begin
  require 'jpmobile'
rescue LoadError, NameError => e
  $stderr.puts "You don't have jpmobile installed in your application. " +
               "Please add it to your Gemfile and run bundle install or rails plugin install from github's repository"
  raise e
end

ActiveSupport.on_load(:action_controller) do
  require 'galapagos_mobile/trans_sid'
end

if defined?(Devise)
  require 'galapagos_mobile/devise'
end
