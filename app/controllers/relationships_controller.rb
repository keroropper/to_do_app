class RelationshipsController < ApplicationController
  def create
    @user = User.find(params[:id])
    current_user.follow(@user)
    respond_to do |format|
      format.html { redirect_to root_path }
      format.js 
    end
  end

  def destroy
    respond_to do |format|
      @user = User.find(params[:id])
      current_user.unfollow(@user)
      respond_to do |format|
        format.html { redirect_to root_path }
        format.js 
      end
    end
  end
end
