class DateFilter < BasicFilter
  AVAILABLE_FILTERS = ["today", "last 3 days", "last 1 week", "last 2 weeks", "last 1 month", "All time"]

  AVAILABLE_FILTERS[1..-2].each do |filter_name|
    num, method = filter_name.match(/^last\s(\d+)\s(\w+)$/).captures
    code = %Q{
      def #{filter_name.gsub(' ', '_').underscore}(relation)
        relation.where("\#{table_name(relation)}.updated_at <= ?", Time.now.utc.beginning_of_day - #{num}.pred.#{method})
      end
    }
    class_eval(code)
  end

  def today(relation)
    relation.where("#{table_name(relation)}.updated_at <= ?", Time.now.utc.beginning_of_day)
  end

  def all_time(relation)
    relation
  end

end