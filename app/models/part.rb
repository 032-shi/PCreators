class Part < ApplicationRecord
  require 'mechanize'

  def self.cpu_scrape
    agent = Mechanize.new
    page = agent.get("https://kakaku.com/pc/cpu/itemlist.aspx?pdf_vi=c")
    name_elements = page.search('span.name2line')
    price_elements = page.search('span.price a')
    image_elements = page.search('span.itemCatImg img')
    manufacturer_elements = page.search('span.maker')

    name_elements.zip(price_elements, image_elements, manufacturer_elements).each do |name_element , price_element , image_element , manufacturer_element|
      if Part.exists?(part_name: name_element.inner_text) #パーツ名でDBとマッチングを行い、保存済みか確認
        price_ele = price_element.inner_text
        part_price = price_ele.delete("^0-9").to_i
        Part.find_by(part_name: name_element.inner_text).update(price: part_price, part_image: image_element.get_attribute(:src))
      else
        part = Part.new
        part.part_name = name_element.inner_text
        part.part_genre = "CPU"
        spec = name_element.inner_text
        if spec.include?("Core i")
          part.part_spec = spec.slice(0..6)
        elsif spec.include?("Ryzen") && spec.exclude?("Threadripper")
          part.part_spec = spec.slice(0..6)
        elsif spec.include?("Celeron")
          part.part_spec = spec.slice(0..6)
        elsif spec.include?("Pentium")
          part.part_spec = spec.slice(0..6)
        elsif spec.include?("Xeon")
          part.part_spec = spec.slice(0..3)
        elsif spec.include?("Ryzen") && spec.include?("Threadripper")
          part.part_spec = spec.slice(0..17)
        else
          part.part_spec = "その他"
        end
        part.manufacturer = manufacturer_element.inner_text
        price = price_element.inner_text
        part.price = price.delete("^0-9").to_i
        part.part_image = image_element.get_attribute(:src)
        part.save
      end
    end
  end
end
