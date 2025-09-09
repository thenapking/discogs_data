class Genre < ApplicationRecord
  has_and_belongs_to_many :master_releases, join_table: "master_releases_genres"
  has_many :genre_summaries, dependent: :destroy

  validates :name, uniqueness: true
end
