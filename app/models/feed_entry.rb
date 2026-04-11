class FeedEntry < ApplicationRecord
  belongs_to :feed_source

  validates :entry_id, presence: true, uniqueness: { scope: :feed_source_id }
  validates :title, presence: true
  validates :url, presence: true

  scope :recent, -> { order(published_at: :desc) }
end
