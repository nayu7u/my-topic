require "uri"

class FeedEntry < ApplicationRecord
  belongs_to :feed_source

  validates :entry_id, presence: true, uniqueness: { scope: :feed_source_id }
  validates :title, presence: true
  validates :url, presence: true,
                  format: { with: URI::DEFAULT_PARSER.make_regexp(%w[http https]) }

  scope :recent, -> { order(published_at: :desc) }
end
