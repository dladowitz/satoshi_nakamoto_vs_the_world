class Tracker < ApplicationRecord
  belongs_to :user

  validates :name, :start_date, :asset_one, :asset_two, :user_id, presence: true
end
