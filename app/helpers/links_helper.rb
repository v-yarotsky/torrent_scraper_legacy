module LinksHelper

  def remote_link_to_download(torrent)
    link_to "Download!", download_torrents_path, :request => :post, :class => "remote action download", "data-id" => torrent.to_param
  end

  def remote_link_to_delete(object)
    method = "#{object.class.name.underscore}_path"
    url = send(method, object)
    link_to "Delete", url, :request => :delete, :confirm => "Are you sure?", :class => "remote action delete"
  end
  
  def remote_link_to_delete_torrent(torrent)
    link_to "Delete", torrents_path, :request => :delete, :confirm => "Are you sure?", :class => "remote action delete", "data-id" => torrent.to_param
  end

  def link_to_delete(object)
    method = "#{object.class.name.underscore}_path"
    url = send(method, object)
    link_to "Delete", url, :method => :delete, :confirm => "Are you sure?", :class => "action delete"
  end

  def link_to_add(object)
    method = "new_#{object}_path"
    url = send(method)
    link_to "New", url, :class => "action add with_text"
  end

  def link_to_edit(object)
    method = "edit_#{object.class.name.underscore}_path"
    url = send(method, object)
    link_to "Edit", url, :class => "action edit"
  end

  def link_to_show(object)
    method = "#{object.class.name.underscore}_path"
    url = send(method, object)
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

end
