class Batch::ScrapingBatch
  def self.scrapeBatch
    Part.part_scrape
    time = Time.current
    puts "スクレイピング実行　" + time.strftime("%a %b %d %H:%M:%S")
  end
end