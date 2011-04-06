# -*- coding: utf-8 -*-
# 
# /config/initializers/devise.rb 
# Devise.setup do |config| 
#   ... 
#   config.warden do |manager| 
#     manager.failure_app = GalapagosMobile::FailureApp
#   end 
# end
# 
# resources
#   from jpmobile/trans_sid.rb -v 1.0.0.pre
#   from devise/failure_app.rb -v 0.1.8
# 
module GalapagosMobile
  class FailureApp < ::Devise::FailureApp
    class_inheritable_accessor :trans_sid_mode
    # Set trans_sid_mode if you want to use others.
    # ex. ::Devise::FailureApp.trans_sid_mode = :always
    #     in config/initializers/galapagos_mobile.rb
    self.trans_sid_mode = :mobile

    protected
    # URLにsession_idを追加する。
    def default_url_options
      result = super || {}
      return result unless request # for test process
      return result unless apply_trans_sid?
      return result.merge({session_key => jpmobile_session_id})
    end

    # override
    def http_auth?
      if request.xhr?
        ::Devise.http_authenticatable_on_xhr
      elsif http_auth_header?
        !(request_format && ::Devise.navigational_formats.include?(request_format))
      else
        false
      end
    end

    # from Devise -v 1.2.0
    # It does not make sense to send authenticate headers in ajax requests
    # or if the user disabled them.
    def http_auth_header?
      ::Devise.mappings[scope].to.http_authenticatable && !request.xhr?
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
