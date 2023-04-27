class Batch::ScrapingBatch
  def self.scrapeBatch
    @logger = Logger.new('log/batch.log')
    time = Time.current
    @logger.info('scrapeBatch実行開始 ' + time.strftime("%Y-%m-%d %H:%M:%S"))
    begin
      Part.part_scrape
      @logger.info('scrapeBatch実行完了 ' + time.strftime("%Y-%m-%d %H:%M:%S"))
    rescue => e
      @logger.error(e)
    end
  end
end