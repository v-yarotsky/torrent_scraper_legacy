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
  
  def torrents_for_tracker(tracker)
    torrents.select { |torrent| torrent.tracker_id == tracker.id }
  end
  
  def torrents_for_tracker_and_tracker_category(tracker, tracker_category)
    torrents.select { |torrent| torrent.tracker_id == tracker.id && torrent.tracker_category_id == tracker_category.id }
  end

end
