module Tasks
  class ReportService < ApplicationService
    def call
      total_count = Task.count
      counts = Task.group(:status).count
      completed_count = counts['completed'] || 0

      count_by_status = {
        not_started: counts['not_started'] || 0,
        in_progress: counts['in_progress'] || 0,
        completed: completed_count
      }

      completion_rate = if total_count.zero?
                          0.0
                        else
                          (completed_count.to_f / total_count * 100).round(1)
                        end

      ServiceResult.success(
        total_count: total_count,
        count_by_status: count_by_status,
        completion_rate: completion_rate
      )
    end
  end
end
