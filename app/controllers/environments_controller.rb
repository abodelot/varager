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

  # PATCH /environments/:slug/add_user
  def add_user
    @environment = Environment.find_by_slug!(params[:id])
    user = User.where(:email => params[:email]).first
    if !user
      flash[:alert] = "No user for email #{params[:email]}"
    else
      @environment.users << user
      flash[:notice] = "Email #{params[:email]} added"
    end
    redirect_to :action => :users, :id => @environment.name
  end

  def new
    @environment = Environment.new
    @environment.parent_id = Environment.where(:name => params[:id]).first
  end

  def create
    environment = Environment.create!(environment_params)
    environment.users << current_user
    redirect_to environment
  end

  private

  def build_treeview
    # Get all environments in a tree structure
    @treeview_root = Environment.arrange
  end

  def environment_params
    params.require(:environment).permit(:name, :parent_id)
  end
end
