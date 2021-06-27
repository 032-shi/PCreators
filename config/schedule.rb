# wheneverは読み込まれるときにrailsを起動する必要がある。また、Rails.rootを使用するために必要。
require File.expand_path(File.dirname(__FILE__) + "/environment")
# cronを実行する環境変数
rails_env = ENV['RAILS_ENV'] || :development
# cronを実行する環境変数をセット
set :environment, rails_env

# cronのログの吐き出し場所。ここでエラー内容を確認する
set :output, "#{Rails.root}/log/cron.log"

every 1.day, at: '11:45 am' do #日本時間では+9時間になる
  runner "Batch::ScrapingBatch.scrapeBatch"
end