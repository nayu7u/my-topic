class FeedEntriesController < ApplicationController
  def index
    @feed_sources = FeedSource.all
    @entries = if params[:feed_source_id].present?
      FeedEntry.includes(:feed_source).where(feed_source_id: params[:feed_source_id]).recent
    else
      FeedEntry.includes(:feed_source).recent
    end
  end
end
