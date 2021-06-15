class Part < ApplicationRecord
  has_many :part_tag_maps, dependent: :destroy
  has_many :part_tags, through: :part_tag_maps
  require 'mechanize'

  def self.cpu_scrape
    agent = Mechanize.new
    page = agent.get("https://kakaku.com/pc/cpu/itemlist.aspx?pdf_vi=c")
    name_elements = page.search('span.name2line')
    price_elements = page.search('span.price a')
    image_elements = page.search('span.itemCatImg img')
    manufacturer_elements = page.search('span.maker')

    name_elements.zip(price_elements, image_elements, manufacturer_elements).each do |name_element , price_element , image_element , manufacturer_element|
      if Part.exists?(name: name_element.inner_text) #パーツ名でDBとマッチングを行い、保存済みか確認
        price_ele = price_element.inner_text
        part_price = price_ele.delete("^0-9").to_i
        Part.find_by(name: name_element.inner_text).update(price: part_price, image: image_element.get_attribute(:src))
      else
        part = Part.new
        part.name = name_element.inner_text
        price = price_element.inner_text
        part.price = price.delete("^0-9").to_i
        part.image = image_element.get_attribute(:src)
        genre_tag = "CPU"
        spec = name_element.inner_text
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
        manufacturer_tag = manufacturer_element.inner_text
        tag_lists = genre_tag, spec_tag, manufacturer_tag
        part.save
        part.save_part_tag(tag_lists) #以下でsave_part_tagメソッドを定義している
      end
    end
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
