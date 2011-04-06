# -*- coding: utf-8 -*-
# monkey patching for jpmobile 0.1.4 + devise 1.1.6
module GalapagosMobile
  module Devise
    module Controllers
      module Helpers
        extend ActiveSupport::Concern

        included do
          alias_method_chain :sign_in_and_redirect, :jpmobile
        end

        module InstanceMethods
          def sign_in_and_redirect_with_jpmobile(resource_or_scope, resource=nil)
            scope      = ::Devise::Mapping.find_scope!(resource_or_scope)
            resource ||= resource_or_scope
            sign_in(scope, resource) unless warden.user(scope) == resource
            redirect_url = stored_location_for(scope) || after_sign_in_path_for(resource)
            # 古いsession_idが付いているとjpmobileが新しいsession_idを付与しないので、強制的に古いsession_idをクリアする
            redirect_url.gsub!(/#{session_key}=[^&]*&?/, '') if respond_to?(:session_key, true)
            redirect_to redirect_url
          end
        end
      end
    end
  end
end

module ActionDispatch::Routing
  class RouteSet #:nodoc:
    # Ensure Devise modules are included only after loading routes, because we
    # need devise_for mappings already declared to create filters and helpers.
    def finalize_with_galapagos_mobile!
      finalize_without_galapagos_mobile!
      ActionController::Base.send :include, GalapagosMobile::Devise::Controllers::Helpers
    end
    alias_method_chain :finalize!, :galapagos_mobile
  end
end
