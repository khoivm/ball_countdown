class GumtreeController < ApplicationController

  def index
    @watchers = GumtreeWatcher.all
  end

  def get_items
    gumtree = Nokogiri::HTML(open('https://www.gumtree.com.au/s-victoria-park-perth/l3008621r50?ad=offering&price-type=free'))
    # return render json: gumtree.to_html
    items = []
    gumtree.css("#srchrslt-adtable li").each do |li|
      item = {}
      item['title'] = li.css('h6.ad-listing__title span').text
      item['img'] = li.at('a.ad-listing__thumb-link img/@src').to_s
      item['description'] = li.css('p.ad-listing__description').text
      item['time'] = li.css('div.ad-listing__date').text
      item['area'] = li.css('span.ad-listing__location-area').text
      item['location'] = li.css('span.ad-listing__location-suburb').text
      item['link'] = "https://www.gumtree.com.au" + li.at('a.ad-listing__thumb-link/@href').to_s
      item['g_id'] = li.at('@data-add-id').to_s
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