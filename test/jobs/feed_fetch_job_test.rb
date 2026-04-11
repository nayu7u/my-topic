require "test_helper"

class FeedFetchJobTest < ActiveJob::TestCase
  ATOM_FEED_XML = File.read(Rails.root.join("test/fixtures/files/atom_feed.xml"))

  test "perform は FeedSource.fetch_all! を呼ぶこと" do
    FeedSource.all.each do |source|
      stub_request(:get, source.url).to_return(body: ATOM_FEED_XML, status: 200)
    end

    FeedFetchJob.perform_now

    FeedSource.all.each do |source|
      assert_not_nil source.reload.fetched_at
    end
  end
end
