require "test_helper"

class FeedEntryTest < ActiveSupport::TestCase
  test "feed_source, entry_id, title, url が必須であること" do
    entry = FeedEntry.new
    assert_not entry.valid?
    assert_includes entry.errors.details[:feed_source], { error: :blank }
    assert_includes entry.errors.details[:entry_id], { error: :blank }
    assert_includes entry.errors.details[:title], { error: :blank }
    assert_includes entry.errors.details[:url], { error: :blank }
  end

  test "同じ feed_source 内で entry_id が一意であること" do
    existing = feed_entries(:rails_entry_one)
    duplicate = FeedEntry.new(
      feed_source: existing.feed_source,
      entry_id: existing.entry_id,
      title: "Duplicate",
      url: "https://example.com/dup"
    )
    assert_not duplicate.valid?
    assert_includes duplicate.errors.details[:entry_id], { error: :taken, value: existing.entry_id }
  end

  test "異なる feed_source では同じ entry_id を持てること" do
    existing = feed_entries(:rails_entry_one)
    entry = FeedEntry.new(
      feed_source: feed_sources(:ruby_weekly),
      entry_id: existing.entry_id,
      title: "Different source entry",
      url: "https://example.com/different"
    )
    assert entry.valid?
  end

  test "published_at の降順スコープが機能すること" do
    entries = FeedEntry.recent
    dates = entries.map(&:published_at).compact
    assert_equal dates, dates.sort.reverse
  end
end
