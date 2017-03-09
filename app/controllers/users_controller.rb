class UsersController < ApplicationController
  before_action :set_user, only: [:destroy]

  def home
  end

  def index
    @users = User.all
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)

    respond_to do |format|
      if @user.save
        format.html { redirect_to new_user_path, notice: 'User was successfully created.' }
      else
        format.html { render :new }
      end
    end
  end

  def destroy
    @user.destroy
    respond_to do |format|
      format.html { redirect_to users_url, notice: 'User was successfully destroyed.' }
    end
  end

  private
   
    def set_user
      @user = User.find(params[:id])
    end

   
    def user_params
      params.require(:user).permit(:name)
    end
end
