module TableHeaderHelper

  class TableHeader < BlockHelpers::Base

    def initialize(tracker, media_category)
      @tracker = tracker
      @media_category = media_category
    end

    def display(body)
      content_tag :thead, body
    end

    def sortable_column(column_name, options = {})
      column_title = options[:title] || column_name.to_s.humanize
      generic_options = {
        :class => "sortable",
        "data-url" => sort_torrents_path(@tracker.id, @media_category.id),
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
      html = content_tag :th, title, options
      html.html_safe
    end

    private

    def search_field(column_name)
      search_field = content_tag :div, :class => "search" do
        content_tag(:span, "[Q]", :class => "search_toggler") +
        text_field_tag(:query, "", "data-url" => search_torrents_path(@tracker.id, @media_category.id),
                                   "data-column" => column_name)
      end
      search_field.html_safe
    end

  end

end