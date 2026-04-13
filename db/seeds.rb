# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

# RSS フィードソースの初期データ
[
  { name: "This Week in Rails", url: "https://world.hey.com/this.week.in.rails/feed.atom" },
  { name: "Ruby Weekly",        url: "https://cprss.s3.amazonaws.com/rubyweekly.com.xml" }
].each do |attrs|
  FeedSource.find_or_create_by!(url: attrs[:url]) do |source|
    source.name = attrs[:name]
  end
end

puts "FeedSource レコード数: #{FeedSource.count}"
