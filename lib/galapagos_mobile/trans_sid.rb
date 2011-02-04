# -*- coding: utf-8 -*-
class ActionDispatch::Request
  def reset_session_with_jpmobile
    reset_session_without_jpmobile
    # DocomoでSSLを使用するとsession_idが変更されるため、
    # Cookie非対応の携帯でもsession_idをパラメータで引き回す。
    if self.mobile? # && !self.mobile.supports_cookie?
      self.session_options[:id] = ActiveSupport::SecureRandom.hex(16)
      if Rails.application.config.session_store == ActiveRecord::SessionStore
        @env[ActiveRecord::SessionStore::SESSION_RECORD_KEY] = nil
      end
    end
  end
  alias_method_chain :reset_session, :jpmobile
end
