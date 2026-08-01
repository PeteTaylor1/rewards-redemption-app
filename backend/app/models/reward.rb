class Reward < ApplicationRecord
  has_many :redemptions, dependent: :restrict_with_error
  has_many :users, through: :redemptions

  validates :name, presence: true
  validates :points_cost, numericality: { greater_than: 0 }
end
