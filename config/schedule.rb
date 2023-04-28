# wheneverは読み込まれるときにrailsを起動する必要がある。また、Rails.rootを使用するために必要。
require File.expand_path(File.dirname(__FILE__) + "/environment")
# Railsアプリの実行環境を指定する環境変数をセットする
rails_env = ENV['RAILS_ENV'] || :development
# cronを実行する際の環境変数をセットする
set :environment, rails_env

# cronのログの吐き出し場所。ここでエラー内容を確認する
set :output, "#{Rails.root}/log/cron.log"

# システム(アプリがデプロイされているマシン)の環境変数をセットする
set :path_env, ENV['PATH']
# cronにて実行する前に下記のjob_typeに従ってコマンドを変換して実行する(デフォルトだとシステム準拠のRubyが使用され、アプリのRubyと差異が発生したため、この変換処理を追加)
job_type :runner, "cd :path && PATH=':path_env' bin/rails runner -e :environment ':task' :output"

# 毎日、AM1:00にバッチを実行する
every 1.day, at: '1:00 am' do
  runner "Batch::ScrapingBatch.scrapeBatch"
end