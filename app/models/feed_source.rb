class FeedSource < ApplicationRecord
  has_many :feed_entries, dependent: :destroy

  validates :name, presence: true
  validates :url, presence: true, uniqueness: true

  def fetch!
    response = Net::HTTP.get(URI(url))
    feed = Feedjira.parse(response)
    feed.entries.each do |entry|
      feed_entries.find_or_initialize_by(entry_id: entry.entry_id).tap do |e|
        e.title = entry.title
        e.url = entry.url
        e.summary = entry.summary
        e.published_at = entry.published
        e.save!
      end
    end
    update!(fetched_at: Time.current)
  end

  def self.fetch_all!
    all.each(&:fetch!)
  end
end
