class Api::RedemptionsController < ApplicationController
  # Demo: always use user id 1
  DEMO_USER_ID = 1

  def index
    user = User.find(DEMO_USER_ID)
    redemptions = user.redemptions.includes(:reward).order(created_at: :desc)
    render json: redemptions.map { |r|
      {
        id: r.id,
        reward_name: r.reward.name,
        points_spent: r.points_spent,
        redeemed_at: r.created_at
      }
    }
  end

  def create
    user = User.find(DEMO_USER_ID)
    reward = Reward.find(params[:reward_id])

    if user.points_balance < reward.points_cost
      return render json: { error: "Insufficient points balance" }, status: :unprocessable_entity
    end

    ActiveRecord::Base.transaction do
      redemption = user.redemptions.create!(
        reward: reward,
        points_spent: reward.points_cost
      )
      user.update!(points_balance: user.points_balance - reward.points_cost)

      render json: {
        id: redemption.id,
        reward_name: reward.name,
        points_spent: redemption.points_spent,
        remaining_balance: user.points_balance,
        redeemed_at: redemption.created_at
      }, status: :created
    end
  rescue ActiveRecord::RecordNotFound
    render json: { error: "Reward not found" }, status: :not_found
  rescue ActiveRecord::RecordInvalid => e
    render json: { error: e.record.errors.full_messages.join(", ") }, status: :unprocessable_entity
  end
end
