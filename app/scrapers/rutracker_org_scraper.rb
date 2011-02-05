#encoding: utf-8
class RutrackerOrgScraper
  include XbttScraper

  def login_form_criteria
    { :action => "http://login.rutracker.org/forum/login.php" }
  end

  def search_form_criteria
    { :action => 'tracker.php' }
  end

  def set_specific_options(form)
    form.field('tm').option_with(:text => /сегодня/i).select
    form.checkbox('oop').check #поиск по торрентам с сидерами
  end

  def torrent_line_xpath
    './/tr[@class="tCenter hl-tr"]'
  end

  def get_torrent_category_name(row)
    row.at_css("a.gen.f").text
  end

  def get_torrent_attributes(row)
    torrent_attributes = {
      :title => row.at_css('a.med.tLink').text,
      :link => row.at_css("a.tr-dl").attr("href"),
      :tracker_link => form_link(row.at_css('a.med.tLink')),
      :size => Utils.parse_size(row.at_css("a.tr-dl").text),
      :seeders => row.at_css("td.seedmed b").text.to_i,
    }
  end

  def torrent_link_prefix
    @tracker.url.gsub /index\.php/,''
  end

end
