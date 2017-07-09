class GumtreeWatcher < ApplicationRecord

  def self.get_matched_items(items)
    watchers = GumtreeWatcher.all
    # return render json: watchers.to_json

    ids = []
    items.each do |item|
      watchers.each do |w|
        if self::matching(item, w)
          ids << item['g_id']
          break
        end
      end
    end

    ids
  end

  private
  def self.matching(item, watcher)
    return item['title'].strip.downcase.include? watcher.name
  end
end
