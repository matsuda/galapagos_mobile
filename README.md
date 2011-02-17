# GalapagosMobile

jpmobileプラグインを使用した場合に発生する不具合を解消するためのmonkey patchプラグイン

## required

以下の環境で動作確認

* Rails : 3.0.4
* jpmobile : 0.1.4
* devise : 1.1.5 〜 1.1.6 （利用する場合）

## install

### Rails pluginとしてインストール  

    $ rails plugin install git://github.com/matsuda/galapagos_mobile.git


### gemとしてインストール

Gemfileに以下を記述

    gem 'galapagos_mobile'
    
bundle

    $ bundle

## 実装されている機能

* Cookie非対応の携帯でログイン処理を可能にする。

* Deviseプラグインを利用している場合に authenticate_{scope}! メソッドで　invalidだった場合にsession_idを引き継がせる。  

login画面へのリダイレクト時にsession_idを付与し、login後に元の画面へリダイレクトバックする時に古いsession_idを削除する。
