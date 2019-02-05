class Flat < ApplicationRecord
  monetize :price_cents

  belongs_to :building
end
