class Filter

  include Singleton

  def filter(relation, options = {})
    return relation if relation.blank?
    raise ArgumentError.new("Hash must be passed") unless options.is_a? Hash

    options.each do |filter_name, value|
      if (filter = get_filter(relation.klass, filter_name))
        Rails.logger.info("Filter: #{filter_name}, #{value}")
        relation &= filter.filter(value, relation) if filter
      end
    end

    relation
  end

  protected

  def get_filter(klass, filter_name)
    filter = nil
    if Dir.open(filters_dir(klass)).entries.include? "#{filter_name}_filter.rb"
      filter = self.class.const_get("#{filter_name.capitalize}Filter").new
    end
    filter
  end

  def filters_dir(klass)
    File.join(Rails.root, 'lib', 'filters', klass.name.underscore.pluralize)
  end

end