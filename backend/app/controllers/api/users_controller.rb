class Api::UsersController < ApplicationController
  # For simplicity this demo uses a single hardcoded user (id: 1).
  # In a real app you would authenticate and use current_user.
  def show
    user = User.find(params[:id])
    render json: {
      id: user.id,
      name: user.name,
      points_balance: user.points_balance
    }
  end
end
