require 'auth'

class ApplicationController < ActionController::API

  before_action :authenticate

  def logged_in?
    !!current_user
  end

  def current_user
    if auth_present?
      user = User.find(auth["user"])
      if user
        @current_user ||= user
      end
    end
  end

  def authenticate
    render json: {error: "unauthorized"}, status: 401 unless logged_in?
  end

  private

    def token
      puts request.headers["Authorization"].split(" ").last
      request.headers["Authorization"].split(" ").last
    end

    def auth
      Auth.decode(token)
    end

    def auth_present?
      puts request.headers["Authorization"].split(" ").first.scan(/Bearer/).flatten.first
      !!request.headers["Authorization"].split(" ").first.scan(/Bearer/).flatten.first
    end


end
