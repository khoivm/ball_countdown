class CreateGumtreeWatchers < ActiveRecord::Migration
  def self.up
    create_table :gumtree_watchers do |t|
      t.string :name
      t.timestamps
    end

  end

  def self.down
    drop_table :gumtree_watchers
  end
end
