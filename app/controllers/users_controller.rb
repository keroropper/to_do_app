class UsersController < ApplicationController

  before_action :user_params, except: %i[ index ]
  before_action :side_bar_params, except: %i[ update destroy ]

  def index 
    @users = User.where.not(id: current_user.id)
  end

  def show 
    @created_at_values = @user.tasks.created_at_values
  end

  def edit

  end
  
  def update
    @user.image.attach(params[:user][:image]) if params[:user][:image]
    if request.referer == user_url(@user)
      redirect_to @user 
    else
      if @user.update
        redirect_to @user
      else
        render 'edit'
      end
    end
  end
  
  def following
    @users = @user.followings
    @title = "#{ @users.count }フォロー"
    render 'show_follow'
  end

  def followers
    @users = @user.followers
    @title = "#{ @users.count }フォロワー"
    render 'show_follow'
  end

  def destroy
    @user.image.purge
    @user.attach_default
    redirect_to @user
  end

  private

    def user_params
      require(:user).permit(:name, :email, :password, :password_confirmation, :image)
    end

    def user_params
      @user = User.find(params[:id])
    end
end
