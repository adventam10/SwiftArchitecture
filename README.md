# SwiftArchitecture

このブランチはiOSアプリのプロジェクト構成模索用

## 開発環境
* Xcode 10.2.1
* Swift 5.0
* cocoapods 1.6.1
* ruby 2.6.3

## ライブラリ
下記ライブラリ使用

* Alamofire
* DIkit
* LicensePlist
* R.swift
* ReactiveCocoa
* SVProgressHUD
* Swiftlint

DIKitとReactiveCocoaは利用法を模索中...(使い方が合っているのか不明)
Swiftlintも模索中...
* force_castは許可すべきか（現状は許可）
* empty_count, empty_stringも入れていい気がする（でもあんまガチガチにするのも...）

ライブラリ管理は可能な限りCarthageを使用

Cocoapodsはバージョンを固定するためbundlerを使用

コマンド例

```
bundle exec pod install
```

## 環境設定
ruby設定

```
brew install rbenv
rbenv install 2.6.3
```

bundler設定

```
gem install bundler
bundle install --path vendor
```

## ビルド
carthage update でとりあえずビルドは通るはず

```
carthage update --platform iOS
```

## アーキテクチャ
MVVMっぽいやつ

## 画面構成
Main.storyboardは削除し、画面ごとにXibを作成（１画面１storyboardの方が良いかも？）
