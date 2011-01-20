#encoding: utf-8
class RutrackerOrgScraper < TorrentScraperBase

  def initialize
    super
    @torrent_link_prefix = @tracker.url.gsub /index\.php/,''
  end

  def login
   Rails.logger.debug "____________________________________LOGIN____________________________________________"
   @page = @page.form_with(:action => "http://login.rutracker.org/forum/login.php") do |form|
     form.login_username = @tracker.login
     form.login_password = @tracker.password
   end.click_button
  end

  def logout
    Rails.logger.debug "____________________________________LOGOUT___________________________________________"
    link = @page.link_with(:text => "Выход")
    @page = link.click unless link.nil?
  end

  def set_options
    Rails.logger.debug "____________________________________SET_OPTIONS______________________________________"
    @page = @page.link_with(:text => "Трекер").click
    @page = @page.form_with(:action => 'tracker.php') do |form|
      @tracker.tracker_categories.each do |category|
        Rails.logger.debug("\tCategory id: #{category.id}, name_on_tracker: #{category.name_on_tracker}")
        form.field('f[]').options.find { |option| option.text.include? category.name_on_tracker }.tick
      end
      form.field('tm').option_with(:text => /сегодня/i).select
      form.checkbox('oop').check #поиск по торрентам с сидерами
    end.submit
  end

  def fetch_torrents
    Rails.logger.debug "____________________________________FETCH_TORRENTS___________________________________"
    @torrents = page.search('.//tr[@class="tCenter hl-tr"]').map { |row| parse_torrent(row) }.compact
  end

  def parse_torrent(row)
    category_name_on_tracker = row.at_css("a.gen.f").text
    category = TrackerCategory.where("tracker_id = ? AND name_on_tracker = ?", @tracker.id, category_name_on_tracker).first
    torrent_attributes = {
      :title => row.at_css('a.med.tLink').text,
      :link => row.at_css("a.tr-dl").attr('href'),
      :tracker_link => form_link(row.at_css('a.med.tLink')),
      :size => Utils.parse_size(row.at_css("a.tr-dl").text),
      :seeders => row.at_css("td.seedmed b").text.to_i,
      :tracker_category => category
    }

    Rails.logger.info("Torrent title: #{torrent_attributes[:title].slice(0, 50)}..., media: #{torrent_attributes[:tracker_category].media_category.name}, category: #{torrent_attributes[:tracker_category].name_on_tracker}, seeders: #{torrent_attributes[:seeders]}, size: #{torrent_attributes[:size]}")

    unless check_torrent(torrent_attributes)
      Rails.logger.info("Skip!")
      return nil
    end

    torrent = Torrent.find_or_create_by_link torrent_attributes[:link]
    torrent.update_attributes(torrent_attributes)

    Rails.logger.info("====errors: #{torrent.errors.full_messages.to_sentence}====") if torrent.errors.any?
  end

  def form_link(node)
    return nil unless node.present?
    [@torrent_link_prefix, node.attr('href')].join
  end

end
