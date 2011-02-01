module TorrentsHelper

  def trackers
    Tracker.all
  end

  def filter_select(name)
    filter_name = "#{name}_filter"
    result = ""
    begin
      available_filters = eval("#{filter_name.classify}::AVAILABLE_FILTERS")
      result = select_tag filter_name, options_for_select(available_filters), :id => filter_name, :class => "filter", "data-name" => name
    rescue NameError
      Rails.logger.warn("Retrieve available filter values failed")
    end
    raw result
  end

end
