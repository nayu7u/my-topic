require "test_helper"

class FeedSourceTest < ActiveSupport::TestCase
  ATOM_FEED_XML = File.read(Rails.root.join("test/fixtures/files/atom_feed.xml"))
  RSS_FEED_XML  = File.read(Rails.root.join("test/fixtures/files/rss_feed.xml"))

  # バリデーションのテスト
  test "name と url が必須であること" do
    source = FeedSource.new
    assert_not source.valid?
    assert_includes source.errors.details[:name], { error: :blank }
    assert_includes source.errors.details[:url], { error: :blank }
  end

  test "url が一意であること" do
    source = FeedSource.new(name: "Duplicate", url: feed_sources(:this_week_in_rails).url)
    assert_not source.valid?
    assert_includes source.errors.details[:url], { error: :taken, value: feed_sources(:this_week_in_rails).url }
  end

  test "有効なデータで保存できること" do
    source = FeedSource.new(name: "New Feed", url: "https://example.com/feed.rss")
    assert source.valid?
  end

  # fetch! メソッドのテスト（WebMock を使用）
  test "fetch! は Atom フィードを取得してエントリを保存すること" do
    source = feed_sources(:this_week_in_rails)
    stub_request(:get, source.url).to_return(body: ATOM_FEED_XML, status: 200)

    # フィクスチャには既存エントリが1件ある。フィードには2件ある（両方新規）
    assert_difference "source.feed_entries.count", 2 do
      source.fetch!
    end
  end

  test "fetch! は RSS フィードを取得してエントリを保存すること" do
    source = feed_sources(:ruby_weekly)
    stub_request(:get, source.url).to_return(body: RSS_FEED_XML, status: 200)

    assert_difference "source.feed_entries.count", 2 do
      source.fetch!
    end
  end

  test "fetch! は fetched_at を更新すること" do
    source = feed_sources(:ruby_weekly)
    assert_nil source.fetched_at
    stub_request(:get, source.url).to_return(body: RSS_FEED_XML, status: 200)

    source.fetch!

    assert_not_nil source.reload.fetched_at
  end

  test "fetch! は同じ entry_id のエントリを重複保存しないこと" do
    source = feed_sources(:this_week_in_rails)

    # フィクスチャにある entry_id と同じものを含む Atom フィードを返す
    atom_with_existing = <<~XML
      <?xml version="1.0" encoding="UTF-8"?>
      <feed xmlns="http://www.w3.org/2005/Atom">
        <title>This Week in Rails</title>
        <id>https://world.hey.com/this.week.in.rails</id>
        <entry>
          <id>entry-1</id>
          <title>Updated Entry 1</title>
          <link href="https://world.hey.com/this.week.in.rails/entry-1"/>
          <summary>Updated summary</summary>
          <published>2024-01-15T00:00:00Z</published>
          <updated>2024-01-15T00:00:00Z</updated>
        </entry>
      </feed>
    XML

    stub_request(:get, source.url).to_return(body: atom_with_existing, status: 200)

    assert_no_difference "source.feed_entries.count" do
      source.fetch!
    end
  end

  test "FeedSource.fetch_all! は全フィードソースに対して fetch! を呼ぶこと" do
    FeedSource.all.each do |source|
      stub_request(:get, source.url).to_return(body: ATOM_FEED_XML, status: 200)
    end

    FeedSource.fetch_all!

    FeedSource.all.each do |source|
      assert_not_nil source.reload.fetched_at
    end
  end
end
