module Tasks
  class DuplicateService < BaseService
    def initialize(task)
      @task = task
    end

    def call
      new_task = @task.build_duplicate

      if new_task.save
        ServiceResult.success(new_task)
      else
        ServiceResult.failure(new_task.errors.full_messages)
      end
    end
  end
end
