class CreateFeedEntries < ActiveRecord::Migration[8.1]
  def change
    create_table :feed_entries do |t|
      t.references :feed_source, null: false, foreign_key: true
      t.string :title
      t.string :url
      t.text :summary
      t.datetime :published_at
      t.string :entry_id

      t.timestamps
    end
    add_index :feed_entries, [ :feed_source_id, :entry_id ], unique: true
  end
end
