class Batch::ScrapingBatch
  def self.scrapeBatch
    @logger = Logger.new('log/batch.log')
    @logger.info('scrapeBatch実行開始 ' + Time.current.strftime("%Y-%m-%d %H:%M:%S"))
    begin
      Part.part_scrape
      @logger.info('scrapeBatch実行完了 ' + Time.current.strftime("%Y-%m-%d %H:%M:%S"))
    rescue => e
      @logger.error(e)
    end
  end
  def self.test
    puts 'dadena'
  end
end