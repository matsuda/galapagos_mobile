$:.unshift(File.dirname(__FILE__)) unless $:.include?(File.dirname(__FILE__)) ||
                                          $:.include?(File.expand_path(File.dirname(__FILE__)))

module GalapagosMobile
  class << self
    def add_features_to_rails
      if defined?(Rails)
        require 'galapagos_mobile/rails'
      end
    end

    def setup
      add_features_to_rails
    end
  end
end
