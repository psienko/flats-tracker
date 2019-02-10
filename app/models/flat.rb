class Flat < ApplicationRecord
  monetize :price_cents

  belongs_to :building
  has_many :activity_logs

  delegate :number, to: :building, prefix: true
  delegate :provider, to: :building
end
