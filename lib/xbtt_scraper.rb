#encoding: utf-8
module XbttScraper
  include TrackerScraper

  def initialize
    super
  end

  def login
    super
    Rails.logger.debug "____________________________________LOGIN____________________________________________"
    page.form_with(login_form_criteria) do |form|
      form.login_username = @tracker.login
      form.login_password = @tracker.password
    end.click_button
  end

  def logout
    super
    Rails.logger.debug "____________________________________LOGOUT___________________________________________"
    link = page.link_with(:text => "Выход")
    link.click unless link.nil?
  end

  def set_options
    super
    Rails.logger.debug "____________________________________SET_OPTIONS______________________________________"
    page.link_with(:text => "Трекер").click
    page.form_with(search_form_criteria) do |form|
      @tracker.tracker_categories.each do |category|
        Rails.logger.debug("\tCategory id: #{category.id}, name_on_tracker: #{category.name_on_tracker}")
        option = form.field('f[]').options.find { |option| option.text.include? category.name_on_tracker }
        option.tick if option.present?
      end
      set_specific_options(form)
    end.submit
  end

  def fetch_torrents
    super
    Rails.logger.debug "____________________________________FETCH_TORRENTS___________________________________"
    @torrents = []
    while (link = page.link_with(:text => "След.")).present?
      @torrents.concat page.search(torrent_line_xpath).map { |row| parse_torrent(row) }.compact
      link.click
    end
    @torrents = page.search(torrent_line_xpath).map { |row| parse_torrent(row) }.compact
  end

  def parse_torrent(row)
    category_name_on_tracker = get_torrent_category_name(row)
    category = TrackerCategory.where("tracker_id = ? AND name_on_tracker = ?", @tracker.id, category_name_on_tracker).first
    torrent_attributes = get_torrent_attributes(row).merge({ :tracker_category => category })

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
    [torrent_link_prefix, node.attr('href').gsub(/^\.\//, '')].join
  end

end