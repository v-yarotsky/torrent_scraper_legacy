module GridHelper

  def sortable_column_header(column_name, options = {})
    column_title = options[:title] || column_name.to_s.humanize

    search = ""
    if options[:searchable] == true
      search = %Q{
        <div class="search">
          <span class="search_toggler">[Q]</span>
          <input type="text" name="query"></input>
        </div>
      }
    end

    html = content_tag :th, :class => "sortable", "data-column" => column_name, "data-order" => "asc" do
      search + column_title
    end
    raw html
  end

  def non_sortable_column_header(title = "")
    html = %Q{<th>#{title}</th>}
    raw html
  end

end