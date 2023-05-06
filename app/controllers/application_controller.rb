class ApplicationController < ActionController::Base

  before_action :configure_permitted_parameters, if: :devise_controller?

  private

  def configure_permitted_parameters
    added_attrs = [ :name, :email, :password, :password_confirmation ]
    devise_parameter_sanitizer.permit :sign_up, keys: added_attrs
    devise_parameter_sanitizer.permit :sign_in, keys: added_attrs
  end

  # deviseのログアウトフラッシュメッセージを非表示にする
  def after_logout_path_for(resource_or_scope)
    root_path
  end

  def current_user?
    redirect_to login_url unless current_user
  end

  def my_task?
    unless @task.user == current_user
      redirect_to root_path
    end
  end

  def side_bar_params 
    if current_user
      # タスクが存在する日付を取得するためのメソッド
      @my_created_at_values = current_user.tasks.created_at_values
      # 使用頻度順に取得したtitle属性
      @task_title_count = current_user.tasks.task_title_count
    end
  end
end
