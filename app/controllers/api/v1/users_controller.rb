require 'auth'

class Api::V1::UsersController < ApplicationController

  skip_before_action :authenticate, only: [:create]

  def create
    user = User.find_by(email: user_params[:email].downcase)
    if user
      render json: {request: "exists"}
    else
      User.create(
        first_name: user_params[:firstName],
        last_name: user_params[:lastName],
        company_name: user_params[:company],
        email: user_params[:email].downcase,
        password: user_params[:password]
      )
      render json: {request: "complete"}
    end
  end

  def show
    if params["q"] == "startupName"
      render json: {startupName: @current_user.company_name}, status: 200
    elsif params["q"] == "all"
      render json: {user: @current_user}, status: 200
    end
  end

  private
    def user_params
      params.require(:user).permit(:firstName, :lastName, :company, :email, :password)
    end

end
