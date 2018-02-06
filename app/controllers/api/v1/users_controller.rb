require 'auth'
require 'base64'
require "mini_magick"
require 'aws-sdk'

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

  def upadate_profile_photo
    uploaded_io = params["imageBase64"]
    metadata = uploaded_io.split(",")[0] + ","
    base64_string = uploaded_io[metadata.size..-1]
    blob = Base64.decode64(base64_string)
    image = MiniMagick::Image.read(blob)
    s3 = Aws::S3::Resource.new(
      # credentials: Aws::Credentials.new(Rails.application.secrets.ACCESS_KEY_ID, Rails.application.secrets.SECRET_ACCESS_KEY),
      # region: Rails.application.secrets.AWS_REGION
      credentials: Aws::Credentials.new(ENV["ACCESS_KEY_ID"], ENV["SECRET_ACCESS_KEY"]),
      region: ENV["AWS_REGION"]
    )
    if @current_user.profile_photo.length > 0
      # previous_obj_key = @current_user.profile_photo.split("https://s3.amazonaws.com/" + Rails.application.secrets.AWS_BUCKET + '/')[1]
      # obj = s3.bucket(Rails.application.secrets.AWS_BUCKET).object(previous_obj_key)
      previous_obj_key = @current_user.profile_photo.split("https://s3.amazonaws.com/" + ENV["AWS_BUCKET"] + '/')[1]
      obj = s3.bucket(ENV["AWS_BUCKET"]).object(previous_obj_key)
      obj.delete
    end
    # obj = s3.bucket(Rails.application.secrets.AWS_BUCKET).object("images/testing/profile_images/profile_image_#{@current_user.id}_#{rand(0..10000)}")
    obj = s3.bucket(ENV["AWS_BUCKET"]).object("images/startup/profile_images/profile_image_#{@current_user.id}_#{rand(0..10000)}")
    obj.upload_file(image.path, acl:'public-read')
    # img_url = "https://s3.amazonaws.com/" + Rails.application.secrets.AWS_BUCKET + '/' + obj.key
    img_url = "https://s3.amazonaws.com/" + ENV["AWS_BUCKET"] + '/' + obj.key
    @current_user.update(profile_photo: img_url)
  end

  private
    def user_params
      params.require(:user).permit(:firstName, :lastName, :company, :email, :password)
    end

end
