class StateFilter < BasicFilter
  AVAILABLE_FILTERS = ["pending", "downloaded", "deleted", "all"]

  AVAILABLE_FILTERS[1..-2].each do |filter_name|
    code = %Q{
      def #{filter_name.gsub(' ', '_').underscore}(relation)
        relation.where("\#{table_name(relation)}.#{filter_name} IS NOT NULL")
      end
    }
    class_eval(code)
  end

  def pending(relation)
    relation.where("#{table_name(relation)}.downloaded IS NULL AND deleted IS NULL")
  end

  def all(relation)
    relation
  end

end