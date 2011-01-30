#encoding: utf-8
class TorrentsByScraper < XbttScraper

  def login_form_criteria
    { :action => "./login.php" }
  end

  def search_form_criteria
    { :name => 'post' }
  end

  def set_specific_options(form)
    form.field('tm').option_with(:text => /сегодня/i).select
    form.checkbox('sd').check #поиск по торрентам с сидерами
    form.checkbox('dc').uncheck
    form.checkbox('df').check
  end

  def torrent_line_xpath
    './/tr[@class="tCenter"]'
  end

  def get_torrent_category_name(row)
    row.at_css("a.gen").text
  end

  def get_torrent_attributes(row)
    torrent_attributes = {
      :title => row.at_css('td.row4.med.tLeft a b').text,
      :link => form_link(row.at_css("a.tr-dl")),
      :tracker_link => form_link(row.at_css('td.row4.med.tLeft a')),
      :size => Utils.parse_size(row.at_css("a.tr-dl span.bold").text),
      :seeders => row.at_css("td.seedmed b").text.to_i,
    }
  end

  def torrent_link_prefix
    @tracker.url.gsub /index\.php/,''
  end

end
