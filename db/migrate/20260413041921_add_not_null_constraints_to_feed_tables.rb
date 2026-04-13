class AddNotNullConstraintsToFeedTables < ActiveRecord::Migration[8.1]
  def change
    change_column_null :feed_sources, :name, false
    change_column_null :feed_sources, :url, false
    change_column_null :feed_entries, :entry_id, false
    change_column_null :feed_entries, :title, false
    change_column_null :feed_entries, :url, false
  end
end
