class EnvironmentsController < ApplicationController

  before_action :build_treeview

  def index
    redirect_to Environment.find_by_slug!(Environment::DEFAULT_NAME)
  end

  # GET /environments/:slug
  def show
    @environment = Environment.find_by_slug!(params[:id])
  end

  # GET /environments/:slug/users
  def users
    @environment = Environment.find_by_slug!(params[:id])
    @users = @environment.users
  end

  private

  def build_treeview
    # Get all environments in a tree structure
    @treeview_root = Environment.arrange
  end
end
