class Api::RewardsController < ApplicationController
  def index
    rewards = Reward.order(:points_cost)
    render json: rewards.map { |r|
      {
        id: r.id,
        name: r.name,
        description: r.description,
        points_cost: r.points_cost
      }
    }
  end
end
