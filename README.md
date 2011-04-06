# GalapagosMobile

jpmobileプラグインを使用した場合に発生する不具合を解消するためのmonkey patchプラグイン

## required

以下の環境で動作確認

* Rails : 3.0.4 〜 3.0.6
* jpmobile : 0.1.4 〜 1.0.0.pre
* devise : 1.1.5 〜 1.1.8 （利用する場合）

## install

### gemとしてインストール

Gemfileに以下を記述

    gem 'galapagos_mobile'
    
bundle

    $ bundle

setupメソッドを実行
例えば config/initializers/galapagos_mobile.rb を作って

    GalapagosMobile.setup

と記述する

### Rails pluginとしてインストール

（setupメソッドは不要）

    $ rails plugin install git://github.com/matsuda/galapagos_mobile.git


## Deviseを使用する場合

deviseの初期設定した際に生成される設定ファイル(devise.rb)に以下を設定

    # /config/initializers/devise.rb 
    Devise.setup do |config| 
      ... 
      config.warden do |manager| 
        manager.failure_app = GalapagosMobile::FailureApp
      end 
    end

FailureAppをカスマイズする場合は、

    class CustomFailureApp < GalapagosMobile::FailureApp
    end

を継承して上記のwarden managerにセットする。

## 実装されている機能

* Cookie非対応の携帯でログイン処理を可能にする。

### deviseを使用している場合

* login画面へのリダイレクト時にsession\_idを付与
* login後に元の画面へリダイレクトバックする時に古いsession\_idを削除する。
* authenticate_{scope}! メソッドで　invalidだった場合にsession\_idを引き継がせる。  
