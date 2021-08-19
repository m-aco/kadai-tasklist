class TasksController < ApplicationController
  before_action :require_user_logged_in
  before_action :correct_user, only: [:show, :edit, :destroy]
  
  def index
      @tasks = current_user.tasks.all
  end

  def show
    set_task
  end

  def new
      @task = Task.new
  end

  def create
      @task = current_user.tasks.build(task_params)
    if @task.save
      flash[:success] = 'タスクを作成しました。'
      redirect_to @task
    else
      @tasks = current_user.tasks.order(id: :desc)
      flash.now[:danger] = 'タスクの作成に失敗しました。'
      render :new
    end
  end

  def edit
    set_task
  end

  def update
    set_task
    if @task.update(task_params)
      flash[:success] = 'Task は正常に更新されました'
      redirect_to @task
    else
      flash.now[:danger] = 'Task は更新されませんでした'
      render :edit
    end
  end

  def destroy
    set_task
    @task.destroy
    flash[:success] = 'タスクを削除しました'
    redirect_back(fallback_location: root_path)
  end
  
    private
    
  def set_task
    @task = current_user.tasks.find(params[:id])
  end

  def task_params
    params.require(:task).permit(:status, :content)
  end

  def correct_user
    @task = current_user.tasks.find_by(id: params[:id])
    unless @task
      redirect_to root_url
    end
  end
end
