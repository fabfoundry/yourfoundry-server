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
      # request.headers["Authorization"].split(" ").last
      request.env["HTTP_AUTHORIZATION"].scan(/Bearer(.*)$/).flatten.last.strip
    end

    def auth
      puts Auth.decode(token)
      Auth.decode(token)
    end

    def auth_present?
      # !!request.headers["Authorization"].split(" ").first.scan(/Bearer/).flatten.first
      !!request.env.fetch("HTTP_AUTHORIZATION", "").scan(/Bearer/).flatten.first
    end


end
