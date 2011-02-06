module TrackersHelper

  def link_to_remove_fields(f)
    f.hidden_field(:_destroy) + link_to_function("Delete", "remove_fields(this)", :class => "action delete with_text inline")
  end

  def link_to_add_fields(association, f)
    new_tracker_category = TrackerCategory.new
    fields = f.fields_for(:tracker_categories, new_tracker_category, :child_index => "new_tracker_category") do |builder|
      render("tracker_category_fields", :f => builder)
    end
    link_to_function("Add", ("add_fields(\"#{escape_javascript(fields)}\")"), :class => "action add with_text block")
  end

  def media_category_select(f)
    f.select :media_category_id,
             MediaCategory.options_for_select,
             { :selected => f.object.media_category_id},
             { "data-default" => f.object.media_category_id, "data-url" => create_media_category_path }
  end

end
