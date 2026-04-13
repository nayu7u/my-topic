require "net/http"
require "uri"

class FeedSource < ApplicationRecord
  has_many :feed_entries, dependent: :destroy

  validates :name, presence: true
  validates :url, presence: true, uniqueness: true,
                  format: { with: URI::DEFAULT_PARSER.make_regexp(%w[http https]) }

  def fetch!
    uri = URI(url)
    response = Net::HTTP.start(
      uri.host,
      uri.port,
      use_ssl: uri.scheme == "https",
      open_timeout: 5,
      read_timeout: 10
    ) do |http|
      http.request(Net::HTTP::Get.new(uri.request_uri))
    end

    unless response.is_a?(Net::HTTPSuccess)
      raise "Failed to fetch feed: HTTP #{response.code} #{response.message}"
    end

    feed = Feedjira.parse(response.body)
    feed.entries.each do |entry|
      attributes = {
        title: entry.title,
        url: entry.url,
        summary: entry.summary,
        published_at: entry.published
      }
      begin
        feed_entries.find_or_initialize_by(entry_id: entry.entry_id).tap do |e|
          e.assign_attributes(attributes)
          e.save!
        end
      rescue ActiveRecord::RecordNotUnique
        feed_entries.find_by!(entry_id: entry.entry_id).update!(attributes)
      end
    end
    update!(fetched_at: Time.current)
  end

  def self.fetch_all!
    find_each(&:fetch!)
  end
end
