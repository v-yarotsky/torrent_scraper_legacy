module LinksHelper

  def link_to_download(torrent)
    link_to "Download!", download_torrent_path(torrent.id), :class => "remote action download"
  end

  def link_to_delete(object)
    method = "#{object.class.name.underscore}_path"
    url = send(method, object.id)
    link_to "Delete", url, :request => :delete, :confirm => "Are you sure?", :class => "remote action delete"
  end

  def link_to_add(object)
    method = "new_#{object}_path"
    url = send(method)
    link_to "New", url, :class => "action add with_text"
  end

  def link_to_edit(object)
    method = "edit_#{object.class.name.underscore}_path"
    url = send(method, object.id)
    link_to "Edit", url, :class => "action edit"
  end

  def link_to_show(object)
    method = "#{object.class.name.underscore}_path"
    url = send(method, object.id)
    link_to "Show", url, :class => "action show"
  end

  def link_back_to(object)
    link_to_list_of(object)
  end

  def link_to_list_of(object)
    method = "#{object}_path"
    url = send(method)
    link_to object.to_s.humanize, url
  end

  def link_to_remove_fields(f)
    f.hidden_field(:_destroy) + link_to_function("Delete", "remove_fields(this)", :class => "action delete with_text inline")
  end

  def link_to_add_fields(association, f)
    new_object = f.object.class.reflect_on_association(association).klass.new
    fields = f.fields_for(association, new_object, :child_index => "new_#{association}") do |builder|
      render(association.to_s.singularize + "_fields", :f => builder)
    end
    link_to_function("Add", ("add_fields(this, \"#{association}\", \"#{escape_javascript(fields)}\")"), :class => "action add with_text block")
  end

end
