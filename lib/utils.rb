class Utils
  class << self

    def parse_size(string)
      return 0 if string.blank?
      num = string.to_f
      uom = string[/[A-Z]{2}/]

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