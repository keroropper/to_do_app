class UsersController < ApplicationController

  before_action :user_params, except: %i[ index ]
  before_action :side_bar_params, except: %i[ update destroy ]
  before_action :current_user?


  def index 
    @users = User.where.not(id: current_user.id).page(params[:page])
  end

  def show 
    @other_user_items = @user.tasks.created_at_values
    @created_at_values = Kaminari.paginate_array(@other_user_items).page(params[:page])
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
    @users = current_user.followings.page(params[:page]).per(7)
    @title = "#{ current_user.followings.count }フォロー"
    render 'show_follow'
  end

  def followers
    @users = current_user.followers.page(params[:page]).per(7)
    @title = "#{ current_user.followers.count }フォロワー"
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
