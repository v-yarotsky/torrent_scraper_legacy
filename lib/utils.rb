class Utils
  class << self

    def parse_size(string)
      Rails.logger.debug("#{string.class.name}, #{string.encoding}, #{string.is_utf8?}")

      return 0 if string.blank? or (matches = string.strip.match /^([\d.]+)\s(\w+)$/).blank?
      Rails.logger.debug("PASSED!")
      num = matches[1].strip.to_f
      uom = matches[2].strip

      result = case uom
        when "GB"
          num.gigabytes
        when "MB"
          num.megabytes
      end
      result || 0
    end

  end
end