class Part < ApplicationRecord
  has_many :part_tag_maps, dependent: :destroy
  has_many :part_tags, through: :part_tag_maps
  has_many :draft_configurations, dependent: :destroy

  require 'mechanize'
  # 各パーツ一覧ページのURL
  CPU_URL = 'https://kakaku.com/pc/cpu/itemlist.aspx?pdf_vi=c'
  MEMORY_URL = 'https://kakaku.com/pc/pc-memory/itemlist.aspx?pdf_Spec102=1&pdf_vi=c'
  VIDEO_CARD_URL = 'https://kakaku.com/pc/videocard/itemlist.aspx'
  MOTHER_BOARD_URL = 'https://kakaku.com/pc/motherboard/itemlist.aspx'
  PC_CASE_URL = 'https://kakaku.com/pc/pc-case/itemlist.aspx'
  POWER_SUPPLY_URL = 'https://kakaku.com/pc/power-supply/itemlist.aspx'
  CPU_COOLER_URL = 'https://kakaku.com/pc/cpu-cooler/itemlist.aspx'
  SSD_URL = 'https://kakaku.com/pc/ssd/itemlist.aspx?pdf_Spec104=1'
  HDD_35_URL = 'https://kakaku.com/pc/hdd-35inch/itemlist.aspx'
  HDD_25_URL = 'https://kakaku.com/pc/hdd-25inch/itemlist.aspx'
  # パーツの各種情報のCSSセレクタ
  SPAN_NAME2LINE = 'span.name2line'
  SPAN_PRICE = 'span.price a'
  SPAN_ITEMCATIMG = 'span.itemCatImg img'
  SPAN_MAKER = 'span.maker'
  A_CKITANKER = 'a.ckitanker'
  LI_PRYEN = 'li.pryen a'
  A_WITHICNLIMITED = 'a.withIcnLimited img'
  A_CKITANKER_SPAN = 'a.ckitanker span'
  TR_BORDER_TD_9 = '//tr[@class="tr-border"]/td[position() = 9]'
  TR_BORDER_TD_10 = '//tr[@class="tr-border"]/td[position() = 10]'
  TR_BORDER_TD_11 = '//tr[@class="tr-border"]/td[position() = 11]'
  TR_BORDER_TD_12 = '//tr[@class="tr-border"]/td[position() = 12]'
  # スペック情報の要素を取得するパターンのジャンルをまとめた配列
  ARRAY_OF_SPEC_PATTERN = [
    PartTag::VIDEO_CARD,
    PartTag::MOTHER_BOARD,
    PartTag::PC_CASE,
    PartTag::POWER_SUPPLY,
    PartTag::CPU_COOLER,
    PartTag::SSD,
    PartTag::HDD_35,
    PartTag::HDD_25
  ]

  def self.part_scrape
    @logger = Logger.new('log/batch.log')
    agent = Mechanize.new
    # CPU情報のスクレイピングを行う
    valueForCpuScraping = {
      'genre' => PartTag::CPU,
      'url' => CPU_URL,
      'nameSelector' => SPAN_NAME2LINE,
      'priceSelector' => SPAN_PRICE,
      'imageSelector' => SPAN_ITEMCATIMG,
      'manufacturerSelector' => SPAN_MAKER
    }
    if self.scrape(agent, valueForCpuScraping)
      @logger.info('CPU情報を保存できませんでした。')
    end
    # メモリ情報のスクレイピングを行う
    valueForMemoryScraping = {
      'genre' => PartTag::MEMORY,
      'url' => MEMORY_URL,
      'nameSelector' => SPAN_NAME2LINE,
      'priceSelector' => SPAN_PRICE,
      'imageSelector' => SPAN_ITEMCATIMG,
      'manufacturerSelector' => SPAN_MAKER
    }
    if self.scrape(agent, valueForMemoryScraping)
      @logger.info('メモリ情報を保存できませんでした。')
    end
    # グラフィックボード情報のスクレイピングを行う
    valueForVideoCardScraping = {
      'genre' => PartTag::VIDEO_CARD,
      'url' => VIDEO_CARD_URL,
      'nameSelector' => A_CKITANKER,
      'priceSelector' => LI_PRYEN,
      'imageSelector' => A_WITHICNLIMITED,
      'manufacturerSelector' => A_CKITANKER_SPAN,
      'specSelector' => TR_BORDER_TD_10
    }
    if self.scrape(agent, valueForVideoCardScraping)
      @logger.info('グラフィックボード情報を保存できませんでした。')
    end
    # マザーボード情報のスクレイピングを行う
    valueForMotherBoardScraping = {
      'genre' => PartTag::MOTHER_BOARD,
      'url' => MOTHER_BOARD_URL,
      'nameSelector' => A_CKITANKER,
      'priceSelector' => LI_PRYEN,
      'imageSelector' => A_WITHICNLIMITED,
      'manufacturerSelector' => A_CKITANKER_SPAN,
      'specSelector' => TR_BORDER_TD_11
    }
    if self.scrape(agent, valueForMotherBoardScraping)
      @logger.info('マザーボード情報を保存できませんでした。')
    end
    # PCケース情報のスクレイピングを行う
    valueForPcCaseScraping = {
      'genre' => PartTag::PC_CASE,
      'url' => PC_CASE_URL,
      'nameSelector' => A_CKITANKER,
      'priceSelector' => LI_PRYEN,
      'imageSelector' => A_WITHICNLIMITED,
      'manufacturerSelector' => A_CKITANKER_SPAN,
      'specSelector' => TR_BORDER_TD_9
    }
    if self.scrape(agent, valueForPcCaseScraping)
      @logger.info('PCケース情報を保存できませんでした。')
    end
    # PC電源情報のスクレイピングを行う
    valueForPowerSupplyScraping = {
      'genre' => PartTag::POWER_SUPPLY,
      'url' => POWER_SUPPLY_URL,
      'nameSelector' => A_CKITANKER,
      'priceSelector' => LI_PRYEN,
      'imageSelector' => A_WITHICNLIMITED,
      'manufacturerSelector' => A_CKITANKER_SPAN,
      'specSelector' => TR_BORDER_TD_9
    }
    if self.scrape(agent, valueForPowerSupplyScraping)
      @logger.info('PC電源情報を保存できませんでした。')
    end
    # CPUクーラー情報のスクレイピングを行う
    valueForCpuCoolerScraping = {
      'genre' => PartTag::CPU_COOLER,
      'url' => CPU_COOLER_URL,
      'nameSelector' => A_CKITANKER,
      'priceSelector' => LI_PRYEN,
      'imageSelector' => A_WITHICNLIMITED,
      'manufacturerSelector' => A_CKITANKER_SPAN,
      'specSelector' => TR_BORDER_TD_11
    }
    if self.scrape(agent, valueForCpuCoolerScraping)
      @logger.info('CPUクーラー情報を保存できませんでした。')
    end
    # SSD情報のスクレイピングを行う
    valueForSsdScraping = {
      'genre' => PartTag::SSD,
      'url' => SSD_URL,
      'nameSelector' => A_CKITANKER,
      'priceSelector' => LI_PRYEN,
      'imageSelector' => A_WITHICNLIMITED,
      'manufacturerSelector' => A_CKITANKER_SPAN,
      'specSelector' => TR_BORDER_TD_12,
      'capaSelector' => TR_BORDER_TD_9
    }
    if self.scrape(agent, valueForSsdScraping)
      @logger.info('SSD情報を保存できませんでした。')
    end
    # 3.5インチHDD情報のスクレイピングを行う
    valueForHdd35Scraping = {
      'genre' => PartTag::HDD_35,
      'url' => HDD_35_URL,
      'nameSelector' => A_CKITANKER,
      'priceSelector' => LI_PRYEN,
      'imageSelector' => A_WITHICNLIMITED,
      'manufacturerSelector' => A_CKITANKER_SPAN,
      'specSelector' => TR_BORDER_TD_9
    }
    if self.scrape(agent, valueForHdd35Scraping)
      @logger.info('3.5インチHDD情報を保存できませんでした。')
    end
    # 2.5インチHDD情報のスクレイピングを行う
    valueForHdd25Scraping = {
      'genre' => PartTag::HDD_25,
      'url' => HDD_25_URL,
      'nameSelector' => A_CKITANKER,
      'priceSelector' => LI_PRYEN,
      'imageSelector' => A_WITHICNLIMITED,
      'manufacturerSelector' => A_CKITANKER_SPAN,
      'specSelector' => TR_BORDER_TD_9
    }
    if self.scrape(agent, valueForHdd25Scraping)
      @logger.info('2.5インチHDD情報を保存できませんでした。')
    end
  end

  # パーツ情報のスクレイピング処理
  def self.scrape(agent, valueForScraping)
    # パーツ一覧ページの情報を取得する
    page = agent.get(valueForScraping['url'])
    # パーツ情報を10ページ分取得する
    part_data = {}
    10.times do
      # パーツの各種情報を取得する
      name_elements = page.search(valueForScraping['nameSelector'])
      price_elements = page.search(valueForScraping['priceSelector'])
      image_elements = page.search(valueForScraping['imageSelector'])
      manufacturer_elements = page.search(valueForScraping['manufacturerSelector'])
      # パーツジャンルにより、スペック要素を取得する
      spec_elements = page.search(valueForScraping['specSelector']) if ARRAY_OF_SPEC_PATTERN.include?(valueForScraping['genre'])
      # SSDの場合、容量情報の要素を取得する
      capa_elements = page.search(valueForScraping['capaSelector']) if valueForScraping['genre'] == PartTag::SSD
      # いずれかのパーツ情報が取得できなかった場合、処理を終了する
      if [
        name_elements,
        price_elements,
        image_elements,
        manufacturer_elements
      ]
      .any?(&:blank?)
        return true
      end
      # 取得したパーツの各種情報をハッシュにまとめる
      name_elements.each_with_index do |name_element, index|
        name = name_element.inner_text
        part_data[name] = {
          'price' => price_elements[index].inner_text,
          'img' => image_elements[index].get_attribute(:src),
          'manufacturer' => manufacturer_elements[index].inner_text.gsub(/　| /){""}
        }
        # パーツのスペック情報を取得している場合、下記ブロックの処理を行う
        if spec_elements.present?
          spec = spec_elements[index].inner_text
          # PCケースの場合、さらに置換処理を行う
          if valueForScraping['genre'] === PartTag::PC_CASE
            spec = spec.gsub(/\(|\)|m|x|\d|幅|最大|インチ|まで|\./){""}
          end
          part_data[name]['spec'] = spec
        end
        # パーツの容量情報を取得している場合、下記ブロックの処理を行う
        part_data[name]['capa'] = capa_elements[index].inner_text if capa_elements.present?
      end
      # 次ページボタンの有無を判定する
      next_btn = page.at('.pageNextOn')
      if next_btn
        # 次ページの情報取得を3秒間遅延させる
        sleep 3
        # 次ページボタンがある場合、親要素のaタグをクリックして次ページ情報を取得し、ループする
        page = agent.click(next_btn.parent)
      else
        # 次ページへのリンクがない場合、本ループ処理を抜ける
        break
      end
    end
    # パーツ情報を一つずつ取り出し、保存処理を行う
    part_data.each do |item_name, item|
      item_price = item['price']
      item_img = item['img']
      item_manufacturer = item['manufacturer']
      item_spec = item['spec'] if item['spec'].present?
      item_capa = item['capa'] if item['capa'].present?
      # スペック情報を取得するパターンにて、スペック情報が空の場合は、次ループに移る
      if ARRAY_OF_SPEC_PATTERN.include?(valueForScraping['genre'])
        if item_spec.blank?
          next
        end
      end
      # パーツ名でDBとマッチングを行い、保存済みか確認する
      if Part.exists?(name: item_name)
        # 更新処理
        part = Part.find_by(name: item_name)
        part.part_update(item_price, item_img, part)
      else
        # 新規登録処理
        part = Part.new
        part.new_partsave(item_name, item_price, item_img, part)
      end
      # パーツジャンルによって、それぞれのtagsaveに分岐させる
      case valueForScraping['genre']
      when PartTag::CPU
        part.cpu_tagsave(item_name, item_manufacturer, part)
      when PartTag::MEMORY
        part.memory_tagsave(item_name, item_manufacturer, part)
      when PartTag::VIDEO_CARD
        part.gpu_tagsave(item_spec, item_manufacturer, part)
      when PartTag::MOTHER_BOARD
        part.mb_tagsave(item_spec, item_manufacturer, part)
      when PartTag::PC_CASE
        part.case_tagsave(item_spec, item_manufacturer, part)
      when PartTag::POWER_SUPPLY
        part.power_supply_tagsave(item_spec, item_manufacturer, part)
      when PartTag::CPU_COOLER
        part.cpu_cooler_tagsave(item_spec, item_manufacturer, part)
      when PartTag::SSD
        part.ssd_tagsave(item_spec, item_capa, item_manufacturer, part)
      when PartTag::HDD_35
        part.hdd35_tagsave(item_spec, item_manufacturer, part)
      when PartTag::HDD_25
        part.hdd25_tagsave(item_spec, item_manufacturer, part)
      end
    end
    return false
  end

  def new_partsave(name, price, img, part)
    part.name = name
    part.price = price.delete("^0-9").to_i
    part.image = img
    part.save
  end

  def part_update(price_ele, img, part)
    part_price = price_ele.delete("^0-9").to_i
    part.update(price: part_price, image: img)
  end

  def cpu_tagsave(spec, manufacturer_tag, part)
    genre_tag = PartTag::CPU
    if spec.include?("Core i")
      spec_tag = spec.slice(0..6)
    elsif spec.include?("Ryzen") && spec.exclude?("Threadripper")
      spec_tag = spec.slice(0..6)
    elsif spec.include?("Celeron")
      spec_tag = spec.slice(0..6)
    elsif spec.include?("Pentium")
      spec_tag = spec.slice(0..6)
    elsif spec.include?("Xeon")
      spec_tag = spec.slice(0..3)
    elsif spec.include?("Ryzen") && spec.include?("Threadripper")
      spec_tag = spec.slice(0..17)
    else
      spec_tag = "その他"
    end
    tag_lists = genre_tag, spec_tag, manufacturer_tag
    part.save_part_tag(tag_lists) #以下でsave_part_tagメソッドを定義している
  end

  def memory_tagsave(spec, manufacturer_tag, part)
    genre_tag = PartTag::MEMORY
    if spec.include?("DDR4")
      spec_tag = "DDR4"
    elsif spec.include?("DDR3")
      spec_tag = "DDR3"
    else
      spec_tag = "その他"
    end
    tag_lists = genre_tag, spec_tag, manufacturer_tag
    part.save_part_tag(tag_lists) #以下でsave_part_tagメソッドを定義している
  end

  def gpu_tagsave(spec, manufacturer_tag, part)
    genre_tag = PartTag::VIDEO_CARD
    if spec.include?("NVIDIA")
      spec_tag = spec.gsub(/NVIDIA/,"")
    elsif spec.include?("AMD")
      spec_tag = spec.gsub(/AMD/,"")
    else
      spec_tag = "その他"
    end
    tag_lists = genre_tag, spec_tag, manufacturer_tag
    part.save_part_tag(tag_lists) #以下でsave_part_tagメソッドを定義している
  end

  def mb_tagsave(spec, manufacturer_tag, part)
    genre_tag = PartTag::MOTHER_BOARD
    if spec.include?("INTEL")
      spec_tag = spec.gsub(/INTEL/,"")
    elsif spec.include?("AMD")
      spec_tag = spec.gsub(/AMD/,"")
    else
      spec_tag = "その他"
    end
    tag_lists = genre_tag, spec_tag, manufacturer_tag
    part.save_part_tag(tag_lists)
  end

  def case_tagsave(spec, manufacturer_tag, part)
    genre_tag = PartTag::PC_CASE
    spec_tag = spec.gsub(/Et|TX|EB|d A/, "Et"=>"Ext","TX"=>"TX　", "EB"=>"EB　","d A"=>"dA").split(/[[:blank:]]+/).select(&:present?)
    case_tag_lists = genre_tag, spec_tag, manufacturer_tag
    tag_lists = case_tag_lists.flatten
    part.save_part_tag(tag_lists)
  end

  def power_supply_tagsave(spec_tag, manufacturer_tag, part)
    genre_tag = PartTag::POWER_SUPPLY
    tag_lists = genre_tag, spec_tag, manufacturer_tag
    part.save_part_tag(tag_lists)
  end

  def cpu_cooler_tagsave(spec_tag, manufacturer_tag, part)
    genre_tag = PartTag::CPU_COOLER
    tag_lists = genre_tag, spec_tag, manufacturer_tag
    part.save_part_tag(tag_lists)
  end

  def ssd_tagsave(spec_tag, capa_spec_tag, manufacturer_tag, part)
    genre_tag = PartTag::SSD
    tag_lists = genre_tag, spec_tag, capa_spec_tag, manufacturer_tag
    part.save_part_tag(tag_lists)
  end

  def hdd35_tagsave(spec_tag, manufacturer_tag, part)
    genre_tag = PartTag::HDD
    genre_sub_tag = PartTag::HDD_35
    tag_lists = genre_tag, genre_sub_tag, spec_tag, manufacturer_tag
    part.save_part_tag(tag_lists)
  end

  def hdd25_tagsave(spec_tag, manufacturer_tag, part)
    genre_tag = PartTag::HDD
    genre_sub_tag = PartTag::HDD_25
    tag_lists = genre_tag, genre_sub_tag, spec_tag, manufacturer_tag
    part.save_part_tag(tag_lists) #以下でsave_part_tagメソッドを定義している
  end

  def save_part_tag(tag_lists)
    current_tags = self.part_tags.pluck(:name) unless self.part_tags.nil?
    old_tags = current_tags - tag_lists #既存のタグから登録するタグを除き、残ったタグを抽出
    new_tags = tag_lists - current_tags #登録するタグから既存のタグを除き、残ったタグを抽出

    old_tags.each do |old_tag| #既存のタグを削除する
      self.part_tags.delete PartTag.find_by(name: old_tag)
    end

    new_tags.each do |new_tag| #登録するタグを保存する
      add_tag = PartTag.find_or_create_by(name: new_tag)
      self.part_tags << add_tag
    end
  end
end
