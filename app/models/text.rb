# == Schema Information
#
# Table name: texts
#
#  id         :integer          not null, primary key
#  post       :string           not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Text < ActiveRecord::Base

  URL_PREFIXES = ["http://", "https://"]
  GOOGLE_MAPS_PREFIX = "https://maps.googleapis.com/maps/api/geocode/json?latlng="
  API_KEY = "AIzaSyBQNkbUutzC_u5gbZNFuv87YIl7DySWDLU"

  before_save do
    self.post = parse_input(self.post)
  end

  def parse_input(text)
    items_arr = parse_items(text)
    final_text = []
    items_arr.each {|item| final_text << transform_text(item) }
    final_text.join("")
  end

  def parse_items(text)
    items_arr = []
    chars = text.split("")

    i = 0
    length = 0
    brackets_open = false

    until chars.length == 0 do
      el = chars[i]

      # pulls out anything enclosed in brackets as its own item
      if el == "["
        brackets_open = true
        length += 1
        i += 1
        next
      end

      if el == "]"
        brackets_open = false
        length += 1
        items_arr << chars.shift(length).join("")
        length, i = 0, 0
        next
      end

      if brackets_open && el != "]"
        length += 1
        i += 1
        next
      end

      # checks rest of input and filters out items from spaces, while maintaining order
      if brackets_open == false && el == " "
        items_arr << chars.shift(1).join("")
        next
      end

      if brackets_open == false && el != " "
        if length+1 == chars.length || chars[i+1] == " "
          length += 1
          items_arr << chars.shift(length).join("")
          length, i = 0, 0
          next
        else
          length += 1
          i += 1
          next
        end
      end
    end
    items_arr
  end

  def transform_text(item)
    if item[0] == "["
      return append_address(item)
    elsif is_URL?(item)
      return strip_URL(item)
    elsif item.length == 1
      return item
    elsif item_is_even?(item)
      return item
    else
      return reverse_with_punctuation_check(item)
    end
  end

  def append_address(item)
    latlon = item[1..-2].gsub(/\s+/, "")
    response = HTTParty.get(GOOGLE_MAPS_PREFIX + latlon +'&key=' + API_KEY)
    # puts response.code, response.message, response.headers.inspect
    if response.code == 200
     return item + "(" + JSON.parse(response.body)["results"][0]["formatted_address"] + ")"
    else
      return "()"
    end
  end

  def is_URL?(string)
    URL_PREFIXES.any? do |pref|
      len = pref.length
      string[0...len] == pref
    end
  end

  def item_is_even?(item)
    if !("a".."z").to_a.include?(item.last)
      return (item.length - 1).even?
    else
      return item.length.even?
    end
  end

  def reverse_with_punctuation_check(item)
    if !("a".."z").to_a.include?(item.last)
      return item[0..-2].reverse + item[-1]
    else
      return item.reverse
    end
  end

  def strip_URL(item)
    URL_PREFIXES.each do |pref|
      len = pref.length
      if item[0...len] == pref
        return item[len..-1]
      end
    end
  end

end
