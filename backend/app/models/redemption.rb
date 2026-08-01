class Redemption < ApplicationRecord
  belongs_to :user
  belongs_to :reward

  validates :points_spent, numericality: { greater_than: 0 }
  validate :user_has_enough_points, on: :create

  private

  def user_has_enough_points
    return unless user && reward
    if user.points_balance < reward.points_cost
      errors.add(:base, "Insufficient points balance")
    end
  end
end
