require "test_helper"

class FeedEntriesControllerTest < ActionDispatch::IntegrationTest
  test "GET /feed_entries は200を返すこと" do
    get feed_entries_url
    assert_response :success
  end

  test "GET /feed_entries は全エントリを表示すること" do
    get feed_entries_url
    assert_select "article", count: FeedEntry.count
  end

  test "GET /feed_entries はエントリタイトルを表示すること" do
    get feed_entries_url
    feed_entries(:rails_entry_one, :ruby_weekly_entry_one).each do |entry|
      assert_select "a", text: entry.title
    end
  end

  test "GET /feed_entries?feed_source_id=X はフィルタリングされた結果を返すこと" do
    source = feed_sources(:this_week_in_rails)
    get feed_entries_url, params: { feed_source_id: source.id }
    assert_response :success
    assert_select "article", count: source.feed_entries.count
  end

  test "ルートパスは FeedEntriesController#index を指すこと" do
    assert_recognizes({ controller: "feed_entries", action: "index" }, "/")
  end
end
