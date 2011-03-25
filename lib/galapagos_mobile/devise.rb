# -*- coding: utf-8 -*-
# monkey patching for jpmobile 0.1.4 + devise 1.1.6
module GalapagosMobile
  module Devise
    module FailureApp
      extend ActiveSupport::Concern

      included do
        class_inheritable_accessor :trans_sid_mode
        # Set trans_sid_mode if you want to use others.
        # ex. ::Devise::FailureApp.trans_sid_mode = :always
        #     in config/initializers/galapagos_mobile.rb
        self.trans_sid_mode = :mobile
      end

      module InstanceMethods
        # from jpmobile/trans_sid.rb -v 0.1.4
        protected
        # URLにsession_idを追加する。
        def default_url_options
          result = super || {}
          return result unless request # for test process
          return result unless apply_trans_sid?
          return result.merge({session_key => jpmobile_session_id})
        end

        private
        # session_keyを返す。
        def session_key
          unless key = Rails.application.config.session_options.merge(request.session_options || {})[:key]
            key = ActionDispatch::Session::AbstractStore::DEFAULT_OPTIONS[:key]
          end
          key
        end

        # session_idを返す
        def jpmobile_session_id
          request.session_options[:id] rescue session.session_id
        end
      end
    end

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
      ::Devise::FailureApp.send :include, GalapagosMobile::Devise::FailureApp
      ActionController::Base.send :include, GalapagosMobile::Devise::Controllers::Helpers
    end
    alias_method_chain :finalize!, :galapagos_mobile
  end
end
