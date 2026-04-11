class CreateFeedSources < ActiveRecord::Migration[8.1]
  def change
    create_table :feed_sources do |t|
      t.string :name
      t.string :url
      t.datetime :fetched_at

      t.timestamps
    end
    add_index :feed_sources, :url, unique: true
  end
end
