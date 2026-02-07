module Tasks
  class CreateService < BaseService
    def initialize(params)
      @raw_params = params
    end

    def call
      task_params = build_task_params(@raw_params)
      task = Task.new(task_params)

      if task.save
        ServiceResult.success(task)
      else
        ServiceResult.failure(task.errors.full_messages)
      end
    end
  end
end
