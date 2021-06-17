class Part < ApplicationRecord
  has_many :part_tag_maps, dependent: :destroy
  has_many :part_tags, through: :part_tag_maps
  require 'mechanize'

  def self.part_scrape
    self.cpu_scrape
    self.memory_scrape
    self.gpu_scrape
    self.mb_scrape
    self.case_scrape
    self.power_supply_scrape
    self.cpu_cooler_scrape
    self.ssd_scrape
    self.hdd35_scrape
    self.hdd25_scrape
  end

  def self.cpu_scrape
    agent = Mechanize.new
    page = agent.get("https://kakaku.com/pc/cpu/itemlist.aspx?pdf_vi=c")
    name_elements = page.search('span.name2line')
    price_elements = page.search('span.price a')
    image_elements = page.search('span.itemCatImg img')
    manufacturer_elements = page.search('span.maker')

    name_elements.zip(price_elements, image_elements, manufacturer_elements).each do |name_element , price_element , image_element , manufacturer_element|
      if Part.exists?(name: name_element.inner_text) #パーツ名でDBとマッチングを行い、保存済みか確認
        part = Part.find_by(name: name_element.inner_text)
        price_ele = price_element.inner_text
        part_price = price_ele.delete("^0-9").to_i
        part.update(price: part_price, image: image_element.get_attribute(:src))
        part.cpu_tagsave(name_element.inner_text, manufacturer_element.inner_text, part)
      else
        part = Part.new
        part.name = name_element.inner_text
        price = price_element.inner_text
        part.price = price.delete("^0-9").to_i
        part.image = image_element.get_attribute(:src)
        part.save
        part.cpu_tagsave(name_element.inner_text, manufacturer_element.inner_text, part)
      end
    end
  end

  def self.memory_scrape
    agent = Mechanize.new
    page = agent.get("https://kakaku.com/pc/pc-memory/itemlist.aspx?pdf_Spec102=1&pdf_vi=c")
    name_elements = page.search('span.name2line')
    price_elements = page.search('span.price a')
    image_elements = page.search('span.itemCatImg img')
    manufacturer_elements = page.search('span.maker')

    name_elements.zip(price_elements, image_elements, manufacturer_elements).each do |name_element , price_element , image_element , manufacturer_element|
      if Part.exists?(name: name_element.inner_text) #パーツ名でDBとマッチングを行い、保存済みか確認
        part = Part.find_by(name: name_element.inner_text)
        price_ele = price_element.inner_text
        part_price = price_ele.delete("^0-9").to_i
        part.update(price: part_price, image: image_element.get_attribute(:src))
        part.memory_tagsave(name_element.inner_text, manufacturer_element.inner_text, part)
      else
        part = Part.new
        part.name = name_element.inner_text
        price = price_element.inner_text
        part.price = price.delete("^0-9").to_i
        part.image = image_element.get_attribute(:src)
        part.save
        part.memory_tagsave(name_element.inner_text, manufacturer_element.inner_text, part)
      end
    end
  end

  def self.gpu_scrape
    agent = Mechanize.new
    page = agent.get("https://kakaku.com/pc/videocard/itemlist.aspx")
    name_elements = page.search('a.ckitanker')
    price_elements = page.search('li.pryen a')
    image_elements = page.search('a.withIcnLimited img')
    manufacturer_elements = page.search('a.ckitanker span')
    spec_elements = page.search('//tr[@class="tr-border"]/td[position() = 10]')

    name_elements.zip(price_elements, image_elements, manufacturer_elements, spec_elements).each do |name_element , price_element , image_element , manufacturer_element , spec_element|
      if Part.exists?(name: name_element.inner_text) #パーツ名でDBとマッチングを行い、保存済みか確認
        part = Part.find_by(name: name_element.inner_text)
        price_ele = price_element.inner_text
        part_price = price_ele.delete("^0-9").to_i
        part.update(price: part_price, image: image_element.get_attribute(:src))
        part.gpu_tagsave(spec_element.inner_text, manufacturer_element.inner_text, part)
      else
        part = Part.new
        part.name = name_element.inner_text
        price = price_element.inner_text
        part.price = price.delete("^0-9").to_i
        part.image = image_element.get_attribute(:src)
        part.save
        part.gpu_tagsave(spec_element.inner_text, manufacturer_element.inner_text, part)
      end
    end
  end

  def self.mb_scrape
    agent = Mechanize.new
    page = agent.get("https://kakaku.com/pc/motherboard/itemlist.aspx")
    name_elements = page.search('a.ckitanker')
    price_elements = page.search('li.pryen a')
    image_elements = page.search('a.withIcnLimited img')
    manufacturer_elements = page.search('a.ckitanker span')
    spec_elements = page.search('//tr[@class="tr-border"]/td[position() = 11]')

    name_elements.zip(price_elements, image_elements, manufacturer_elements, spec_elements).each do |name_element , price_element , image_element , manufacturer_element , spec_element|
      if Part.exists?(name: name_element.inner_text) #パーツ名でDBとマッチングを行い、保存済みか確認
        part = Part.find_by(name: name_element.inner_text)
        price_ele = price_element.inner_text
        part_price = price_ele.delete("^0-9").to_i
        part.update(price: part_price, image: image_element.get_attribute(:src))
        part.mb_tagsave(spec_element.inner_text, manufacturer_element.inner_text.gsub(/　| /){""}, part)
      else
        part = Part.new
        part.name = name_element.inner_text
        price = price_element.inner_text
        part.price = price.delete("^0-9").to_i
        part.image = image_element.get_attribute(:src)
        part.save
        part.mb_tagsave(spec_element.inner_text, manufacturer_element.inner_text.gsub(/　| /){""}, part)
      end
    end
  end

  def self.case_scrape
    agent = Mechanize.new
    page = agent.get("https://kakaku.com/pc/pc-case/itemlist.aspx")
    name_elements = page.search('a.ckitanker')
    price_elements = page.search('li.pryen a')
    image_elements = page.search('a.withIcnLimited img')
    manufacturer_elements = page.search('a.ckitanker span')
    spec_elements = page.search('//tr[@class="tr-border"]/td[position() = 9]')

    name_elements.zip(price_elements, image_elements, manufacturer_elements, spec_elements).each do |name_element , price_element , image_element , manufacturer_element , spec_element|
      if Part.exists?(name: name_element.inner_text) #パーツ名でDBとマッチングを行い、保存済みか確認
        part = Part.find_by(name: name_element.inner_text)
        price_ele = price_element.inner_text
        part_price = price_ele.delete("^0-9").to_i
        part.update(price: part_price, image: image_element.get_attribute(:src))
        part.case_tagsave(spec_element.inner_text.gsub(/\(|\)|m|x|\d|幅|最大|インチ|まで|\./){""}, manufacturer_element.inner_text, part)
      else
        part = Part.new
        part.name = name_element.inner_text
        price = price_element.inner_text
        part.price = price.delete("^0-9").to_i
        part.image = image_element.get_attribute(:src)
        part.save
        part.case_tagsave(spec_element.inner_text.gsub(/\(|\)|m|x|\d|幅|最大|インチ|まで|\./){""}, manufacturer_element.inner_text, part)
      end
    end
  end

  def self.power_supply_scrape
    agent = Mechanize.new
    page = agent.get("https://kakaku.com/pc/power-supply/itemlist.aspx")
    name_elements = page.search('a.ckitanker')
    price_elements = page.search('li.pryen a')
    image_elements = page.search('a.withIcnLimited img')
    manufacturer_elements = page.search('a.ckitanker span')
    spec_elements = page.search('//tr[@class="tr-border"]/td[position() = 9]')

    name_elements.zip(price_elements, image_elements, manufacturer_elements, spec_elements).each do |name_element , price_element , image_element , manufacturer_element , spec_element|
      if Part.exists?(name: name_element.inner_text) #パーツ名でDBとマッチングを行い、保存済みか確認
        part = Part.find_by(name: name_element.inner_text)
        price_ele = price_element.inner_text
        part_price = price_ele.delete("^0-9").to_i
        part.update(price: part_price, image: image_element.get_attribute(:src))
        part.power_supply_tagsave(spec_element.inner_text, manufacturer_element.inner_text.gsub(/　| /){""}, part)
      else
        part = Part.new
        part.name = name_element.inner_text
        price = price_element.inner_text
        part.price = price.delete("^0-9").to_i
        part.image = image_element.get_attribute(:src)
        part.save
        part.power_supply_tagsave(spec_element.inner_text, manufacturer_element.inner_text.gsub(/　| /){""}, part)
      end
    end
  end

  def self.cpu_cooler_scrape
    agent = Mechanize.new
    page = agent.get("https://kakaku.com/pc/cpu-cooler/itemlist.aspx")
    name_elements = page.search('a.ckitanker')
    price_elements = page.search('li.pryen a')
    image_elements = page.search('a.withIcnLimited img')
    manufacturer_elements = page.search('a.ckitanker span')
    spec_elements = page.search('//tr[@class="tr-border"]/td[position() = 11]')

    name_elements.zip(price_elements, image_elements, manufacturer_elements, spec_elements).each do |name_element , price_element , image_element , manufacturer_element , spec_element|
      if Part.exists?(name: name_element.inner_text) #パーツ名でDBとマッチングを行い、保存済みか確認
        part = Part.find_by(name: name_element.inner_text)
        price_ele = price_element.inner_text
        part_price = price_ele.delete("^0-9").to_i
        part.update(price: part_price, image: image_element.get_attribute(:src))
        part.cpu_cooler_tagsave(spec_element.inner_text, manufacturer_element.inner_text.gsub(/　| /){""}, part)
      else
        part = Part.new
        part.name = name_element.inner_text
        price = price_element.inner_text
        part.price = price.delete("^0-9").to_i
        part.image = image_element.get_attribute(:src)
        part.save
        part.cpu_cooler_tagsave(spec_element.inner_text, manufacturer_element.inner_text.gsub(/　| /){""}, part)
      end
    end
  end

  def self.ssd_scrape
    agent = Mechanize.new
    page = agent.get("https://kakaku.com/pc/ssd/itemlist.aspx?pdf_Spec104=1")
    name_elements = page.search('a.ckitanker')
    price_elements = page.search('li.pryen a')
    image_elements = page.search('a.withIcnLimited img')
    manufacturer_elements = page.search('a.ckitanker span')
    spec_elements = page.search('//tr[@class="tr-border"]/td[position() = 12]')
    capa_spec_elements = page.search('//tr[@class="tr-border"]/td[position() = 9]')

    name_elements.zip(price_elements, image_elements, manufacturer_elements, spec_elements, capa_spec_elements).each do |name_element , price_element , image_element , manufacturer_element , spec_element , capa_spec_element|
      if Part.exists?(name: name_element.inner_text) #パーツ名でDBとマッチングを行い、保存済みか確認
        part = Part.find_by(name: name_element.inner_text)
        price_ele = price_element.inner_text
        part_price = price_ele.delete("^0-9").to_i
        part.update(price: part_price, image: image_element.get_attribute(:src))
        part.ssd_tagsave(spec_element.inner_text, capa_spec_element.inner_text, manufacturer_element.inner_text.gsub(/　| /){""}, part)
      else
        part = Part.new
        part.name = name_element.inner_text
        price = price_element.inner_text
        part.price = price.delete("^0-9").to_i
        part.image = image_element.get_attribute(:src)
        part.save
        part.ssd_tagsave(spec_element.inner_text, capa_spec_element.inner_text, manufacturer_element.inner_text.gsub(/　| /){""}, part)
      end
    end
  end

  def self.hdd35_scrape
    agent = Mechanize.new
    page = agent.get("https://kakaku.com/pc/hdd-35inch/itemlist.aspx")
    name_elements = page.search('a.ckitanker')
    price_elements = page.search('li.pryen a')
    image_elements = page.search('a.withIcnLimited img')
    manufacturer_elements = page.search('a.ckitanker span')
    spec_elements = page.search('//tr[@class="tr-border"]/td[position() = 9]')

    name_elements.zip(price_elements, image_elements, manufacturer_elements, spec_elements).each do |name_element , price_element , image_element , manufacturer_element , spec_element|
      if Part.exists?(name: name_element.inner_text) #パーツ名でDBとマッチングを行い、保存済みか確認
        part = Part.find_by(name: name_element.inner_text)
        price_ele = price_element.inner_text
        part_price = price_ele.delete("^0-9").to_i
        part.update(price: part_price, image: image_element.get_attribute(:src))
        part.hdd35_tagsave(spec_element.inner_text, manufacturer_element.inner_text.gsub(/　| /){""}, part)
      else
        part = Part.new
        part.name = name_element.inner_text
        price = price_element.inner_text
        part.price = price.delete("^0-9").to_i
        part.image = image_element.get_attribute(:src)
        part.save
        part.hdd35_tagsave(spec_element.inner_text, manufacturer_element.inner_text.gsub(/　| /){""}, part)
      end
    end
  end

  def self.hdd25_scrape
    agent = Mechanize.new
    page = agent.get("https://kakaku.com/pc/hdd-25inch/itemlist.aspx")
    name_elements = page.search('a.ckitanker')
    price_elements = page.search('li.pryen a')
    image_elements = page.search('a.withIcnLimited img')
    manufacturer_elements = page.search('a.ckitanker span')
    spec_elements = page.search('//tr[@class="tr-border"]/td[position() = 9]')

    name_elements.zip(price_elements, image_elements, manufacturer_elements, spec_elements).each do |name_element , price_element , image_element , manufacturer_element , spec_element|
      if Part.exists?(name: name_element.inner_text) #パーツ名でDBとマッチングを行い、保存済みか確認
        part = Part.find_by(name: name_element.inner_text)
        price_ele = price_element.inner_text
        part_price = price_ele.delete("^0-9").to_i
        part.update(price: part_price, image: image_element.get_attribute(:src))
        part.hdd25_tagsave(spec_element.inner_text, manufacturer_element.inner_text.gsub(/　| /){""}, part)
      else
        part = Part.new
        part.name = name_element.inner_text
        price = price_element.inner_text
        part.price = price.delete("^0-9").to_i
        part.image = image_element.get_attribute(:src)
        part.save
        part.hdd25_tagsave(spec_element.inner_text, manufacturer_element.inner_text.gsub(/　| /){""}, part)
      end
    end
  end

  def cpu_tagsave(spec, manufacturer_tag, part)
    genre_tag = "CPU"
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
    genre_tag = "メモリー"
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
    genre_tag = "グラフィックボード"
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
    genre_tag = "マザーボード"
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
    genre_tag = "PCケース"
    spec_tag = spec.gsub(/Et|TX|EB|d A/, "Et"=>"Ext","TX"=>"TX　", "EB"=>"EB　","d A"=>"dA").split(/[[:blank:]]+/).select(&:present?)
    case_tag_lists = genre_tag, spec_tag, manufacturer_tag
    tag_lists = case_tag_lists.flatten
    part.save_part_tag(tag_lists)
  end

  def power_supply_tagsave(spec_tag, manufacturer_tag, part)
    genre_tag = "PC電源"
    tag_lists = genre_tag, spec_tag, manufacturer_tag
    part.save_part_tag(tag_lists)
  end

  def cpu_cooler_tagsave(spec_tag, manufacturer_tag, part)
    genre_tag = "CPUクーラー"
    tag_lists = genre_tag, spec_tag, manufacturer_tag
    part.save_part_tag(tag_lists)
  end

  def ssd_tagsave(spec_tag, capa_spec_tag, manufacturer_tag, part)
    genre_tag = "SSD"
    tag_lists = genre_tag, spec_tag, capa_spec_tag, manufacturer_tag
    part.save_part_tag(tag_lists)
  end

  def hdd35_tagsave(spec_tag, manufacturer_tag, part)
    genre_tag = "HDD"
    genre_sub_tag = "HDD(3.5インチ)"
    tag_lists = genre_tag, genre_sub_tag, spec_tag, manufacturer_tag
    part.save_part_tag(tag_lists)
  end

  def hdd25_tagsave(spec_tag, manufacturer_tag, part)
    genre_tag = "HDD"
    genre_sub_tag = "HDD(2.5インチ)"
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
