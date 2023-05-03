class UsersController < ApplicationController

  def index 
    @users = User.where.not(id: current_user.id)
  end

  def show 
    @user = User.find(params[:id])
  end

  def following
    @title = "フォロー中"
    @user = User.find(params[:id])
    @users = @user.followings
    render 'show_follow'
  end

  def followers
    @title = "フォロワー"
    @user = User.find(params[:id])
    @users = @user.followers
    render 'show_follow'
  end
end
