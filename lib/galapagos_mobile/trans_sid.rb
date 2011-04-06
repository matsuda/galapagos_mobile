# -*- coding: utf-8 -*-
# from jpmobile -v 1.0.0.pre
require 'jpmobile/trans_sid.rb'
module ActionController
  class Metal #:nodoc:
    private
    # trans_sidを適用すべきかを返す。
    def apply_trans_sid?
      # session_id が blank の場合は適用しない
      return false if trans_sid_mode and jpmobile_session_id.blank?

      case trans_sid_mode
      when :always
        session.inspect
        return true
      when :mobile
        # SSLと非SSLでとsession_idが異なる場合に、
        # Cookie非対応の携帯でもsession_idをパラメータで引き回すための対応
        if request.mobile?# and !request.mobile.supports_cookie?
          session.inspect
          return true
        end
      end

      return false
    end
  end
end
