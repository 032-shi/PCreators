# PCreators

## サイト概要
自作PCパーツの使用感やPCの構成などを投稿し、ユーザー同士でコミュニケーションを取ることができるサイトです。自作PCの構成について悩んでいるユーザーが、投稿されたPC構成を参考にしてスペックや価格の比較を行い、パーツの選定に役立てることができます。また、本サイト内でPCパーツ価格の簡易的な相場検索ができます。  
レスポンシブ対応しており、スマホなどの画面サイズでも確認しやすくなっております。  
<div align="center">
<img src="https://user-images.githubusercontent.com/80741205/126058554-ec7c3171-7dd0-4c8b-bcd7-87db23ec32b4.png" width="80%" height="60%">
</div>

### サイトテーマ
自作PC好きが自作PC構成やパーツ情報の共有を行うSNS

### テーマを選んだ理由
私自身が自作PCが趣味であり、自作PCの構成を考えたりパーツ選定をする際は、ネット上のレビューを参考にしておりました。しかし、レビュー情報が様々なサイトに散乱していた為、情報収集に時間がかかっていました。また、自作PCユーザーが少ないということもあり、レビュー記事がないケースもありました。上記のことから、自作PCユーザーを増やしつつ、情報が集中することを期待して本テーマを選択しました。また、PCゲーマーが増えてきている為、自作PCの需要は増加しており、本テーマは自作PC市場にマッチしていると考えております。

### ターゲットユーザ
- 自作PCユーザー
- PCゲーマー
- 自作PCを検討している人

### 主な利用シーン
- PCパーツの使用感などの投稿
- 自作PCの構成の紹介
- PCパーツの相場の検索
- 自作PCのエラー情報の共有

### 機能一覧
- ユーザー登録、ログイン機能(devise)
- 投稿機能、画像投稿機能(refile)
- 投稿のタグ付け機能
- コメント機能、いいね機能(Ajax)
- 投稿、PCパーツ検索機能
- ページネーション機能(kaminari)
- PCパーツスクレイピング機能(mechanize)
- PCパーツデータベース保存のバッチ処理機能(whenever)

## 設計書
[ER図](https://drive.google.com/file/d/1VPB_UAAJ_H8pfzYRLd6EXvTILOXYD4I5/view?usp=sharing)

## チャレンジ要素一覧
https://docs.google.com/spreadsheets/d/1XfdJaihMCiXaT8qO71WGfcby2r3qssYub6CGN0BouMs/edit?usp=sharing

## 開発環境
- OS：Linux(CentOS)
- 言語：HTML,CSS,JavaScript,Ruby,SQL
- フレームワーク：Ruby on Rails
- JSライブラリ：jQuery
- IDE：Cloud9
