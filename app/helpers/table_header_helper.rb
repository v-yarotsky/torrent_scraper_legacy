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

      html = content_tag :th, :class => "sortable",
                              "data-url" => sort_torrents_path(@tracker.id, @media_category.id),
                              "data-column" => column_name,
                              "data-order" => "asc" do
        if options[:searchable] == true
          search_field(column_name) + column_title
        else
          column_title
        end
      end
      raw html
    end

    def column(title = "")
      html = content_tag :th, title
      raw html
    end

    private

    def search_field(column_name)
      search_field = content_tag :div, :class => "search" do
        content_tag(:span, "[Q]", :class => "search_toggler") +
        text_field_tag(:query, "", "data-url" => search_torrents_path(@tracker.id, @media_category.id),
                                     "data-column" => column_name)
      end
      raw search_field
    end

  end

end