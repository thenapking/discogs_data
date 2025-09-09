class MasterRelease < ApplicationRecord
  has_and_belongs_to_many :genres, join_table: "master_releases_genres"
  has_and_belongs_to_many :styles, join_table: "master_releases_styles"
end
