class Building < ApplicationRecord
  has_many :flats
  has_many :activity_logs
end
