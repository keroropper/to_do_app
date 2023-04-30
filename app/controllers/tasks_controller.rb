class TasksController < ApplicationController

  before_action :set_task, only: %i[ toggle edit update destroy ]
  before_action :dairy_tasks, only: %i[ update destroy ]
  before_action :my_task?, only: %i[ edit update delete ]
  before_action :current_user?, except: %i[ home ]
  # before_action :side_bar_params, only: %i[ home index ]

def index 
      # タスクが存在する日付を取得するためのメソッド
      @created_at_values = Task.created_at_values
      # 使用頻度順に取得したtitle属性
      @task_title_count = Task.task_title_count
  # taskを日付でグループ化。{  Sat, 29 Apr 2023=> [taskオブジェクト], ... }
  @tasks_by_date = current_user.tasks.group_by{ |task| task.created_at.to_date }
  # :created_at = "2023-04-29"
  if params[:created_at]
    # "2023-04-29"をDateオブジェクトに変換 => Tur, 29 Apr 2023
    # ↑の{  Sat, 29 Apr 2023=> [taskオブジェクト], ... }のキーに合わせるため
    @date = Date.parse(params[:created_at])
    # { paramsの日付 => グループ化した中から、paramsの日付のオブジェクトを指定 }
    @task_by_date = { @date => @tasks_by_date[@date] }
  end
end 


def home
      # タスクが存在する日付を取得するためのメソッド
      @created_at_values = Task.created_at_values
      # 使用頻度順に取得したtitle属性
      @task_title_count = Task.task_title_count
  @task = Task.new
  if user_signed_in?
    @tasks = current_user.tasks.where(created_at: Date.today.all_day)
  end
end

def create 
  @task = current_user.tasks.build(task_params)
  respond_to do |format|
    if @task.save
      format.html { redirect_to root_url }
      format.js
    else
      flash.now[:danger] = @task.errors.full_messages
      format.html do
        render 'tasks/home'
      end
      format.js { render "create_failure" }
    end
  end
end

def show
  
end

def edit
  respond_to do |format|
    format.js
  end
end

def update
  respond_to do |format|
    @task.assign_attributes(task_params)
    if @task.valid? && @task.save
      format.html { redirect_to root_url }
      format.js { render locals: { task: @task } }
    else
      flash.now[:danger] = @task.errors.full_messages.join('')
      format.html do
        render 'tasks/home'
      end
      format.js { render "create_failure" }
    end
  end
end

def destroy
  @task.delete
  respond_to do |format|
    format.html do
      redirect_to root_url
    end
    format.js { render locals: { task: @task } }
  end
end

def toggle 
  @task.update(completed: !@task.completed)
  respond_to do |format|
    format.html { redirect_to root_url }
    format.js 
  end

end

private

  def set_task
    @task = Task.find(params[:id])
  end

  def dairy_tasks 
    @tasks = current_user.tasks.where(created_at: Date.today.all_day)
  end

  def side_bar_params 
    # タスクが存在する日付を取得するためのメソッド
    @created_at_values = Task.created_at_values
    # 使用頻度順に取得したtitle属性
    @task_title_count = Task.task_title_count
  end

  def task_params 
    params.require(:task).permit(:title, :completed)
  end

  def current_user?
    redirect_to login_url unless current_user
  end

end
