class Style < ApplicationRecord
  has_and_belongs_to_many :master_releases, join_table: "master_releases_styles"
  has_many :style_summaries, dependent: :destroy

  validates :name, uniqueness: true

end
