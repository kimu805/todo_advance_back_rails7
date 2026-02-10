class TasksController < ApplicationController
  before_action :select_task, only: [:update, :destroy, :update_status, :duplicate]
  skip_before_action :verify_authenticity_token

  def index
    tasks_all
  end

  def report
    result = Tasks::ReportService.call
    @report = result.data
  end

  def create
    result = Tasks::CreateService.call(create_params)

    if result.success?
      @result = result.data
      tasks_all
    else
      render json: { errors: result.errors }, status: :unprocessable_entity
    end
  end

  def update
    @task.update(task_params)
    tasks_all
  end

  def destroy
    @task.destroy
    tasks_all
  end

  def update_status
    @task.update(status: params[:status])
    tasks_all
  end

  def duplicate
    result = Tasks::DuplicateService.call(@task)

    if result.success?
      tasks_all
    else
      render json: { errors: result.errors }, status: :unprocessable_entity
    end
  end

  private

  def create_params
    params.permit(:name, :explanation, :status, :priority, :genreId, :deadlineDate)
  end

  def task_params
    params.permit(:name, :explanation, :status, :priority).merge(genre_id: params[:genreId], deadline_date: params[:deadlineDate])
  end

  def select_task
    @task = Task.find(params[:id])
  end

  def tasks_all
    @tasks = Task.all
    render :all_tasks
  end
end
