class GumtreeController < ApplicationController

  def index
    @watchers = GumtreeWatcher.all
  end

  def get_items
    gumtree = Nokogiri::HTML(open('https://www.gumtree.com.au/s-victoria-park-perth/l3008621r50?ad=offering&price-type=free'))
    items = []
    gumtree.css("div.search-results-page__main-ads-wrapper .panel-body .user-ad-row").each do |li|
      item = {}
      item['title'] = li.css('.user-ad-row__title').text
      item['img'] = li.at('img.user-ad-row__image/@src').to_s
      item['description'] = li.css('.user-ad-row__description').text
      item['time'] = li.css('.user-ad-row__age').text
      area = li.css('.user-ad-row__location-area').text
      item['location'] = li.css('.user-ad-row__location').text.gsub(area, area + ', ')
      item['link'] = "https://www.gumtree.com.au" + li.at('@href').to_s
      item['g_id'] = li.at('@aria-describedby').to_s.gsub('user-ad-desc-MAIN-','')
      items << item
    end

    matched_item_ids = GumtreeWatcher.get_matched_items(items)

    render json: {items: items, matches: matched_item_ids}
  end

  def remove_watcher
    id = params[:id]
    return unless id

    GumtreeWatcher.find(id).delete
  end

  def save_watcher
    name = params[:name]
    return unless name

    name.downcase!
    unless GumtreeWatcher.find_by_name(name)
      watcher = GumtreeWatcher.create(name: name)
      if watcher
        render json: watcher.to_json
      end
    end
  end
end