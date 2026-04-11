class FeedFetchJob < ApplicationJob
  queue_as :default

  def perform
    FeedSource.fetch_all!
  end
end
