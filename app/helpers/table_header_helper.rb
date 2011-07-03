module TableHeaderHelper

  class TableHeader < BlockHelpers::Base

    def initialize(tracker, tracker_category)
      @tracker = tracker
      @tracker_category = tracker_category
      @col_options = ""
    end

    def display(body)
      html = content_tag :colgroup, @col_options.html_safe
      html += content_tag :thead, body
      html
    end

    def sortable_column(column_name, options = {})
      @col_options += col(options)
      column_title = options[:title] || column_name.to_s.humanize
      generic_options = {
        :class => "sortable",
        "data-url" => sort_torrents_path(@tracker.id, @tracker_category.id),
        "data-column" => column_name,
        "data-order" => "asc"
      }
      searchable = options.delete :searchable
      html = content_tag :th, generic_options.merge(options) do
        if searchable == true
          search_field(column_name) + column_title
        else
          column_title
        end
      end
      html.html_safe
    end

    def column(title = "", options = {})
      @col_options += col(options)
      html = content_tag(:th, title, options)
      html.html_safe
    end

    private
    
    def col(options)
      html = tag :col, :width => options.delete(:width) || 'auto', :align => options.delete(:align) || 'left'
      html.html_safe
    end

    def search_field(column_name)
      search_field = content_tag :div, :class => "search" do
        content_tag(:span, "[Q]", :class => "search_toggler") +
        text_field_tag(:query, "", "data-url" => search_torrents_path(@tracker.id, @tracker_category.id),
                                   "data-column" => column_name)
      end
      search_field.html_safe
    end

  end

end