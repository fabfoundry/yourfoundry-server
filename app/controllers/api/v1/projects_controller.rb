class Api::V1::ProjectsController < ApplicationController


  def index
    render json: {projects: @current_user.projects}
  end


  def create
    exists = @current_user.projects.select do |project|
      project[:name].downcase == project_params[:newProject].downcase
    end

    if exists.empty?
      @current_user.projects << Project.create(name: project_params[:newProject])
      render json: {request: "complete", projects: @current_user.projects}
    else
      render json: {request: "exists"}
    end
  end

  def destroy
    @current_user.projects.find(params[:id].to_i).destroy
    render json: {request: "complete", projects: @current_user.projects}
  end

  private
    def project_params
      params.require(:project).permit(:newProject)
    end

end
