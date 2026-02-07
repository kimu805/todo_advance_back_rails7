module Tasks
  class BaseService < ApplicationService
    private

    PARAM_MAPPING = {
      genreId: :genre_id,
      deadlineDate: :deadline_date
    }.freeze

    PERMITTED_PARAMS = %i[name explanation status priority genre_id deadline_date].freeze

    def build_task_params(raw_params)
      normalized = normalize_params(raw_params)

      PARAM_MAPPING.each do |camel, snake|
        normalized[snake] = normalized.delete(camel) if normalized.key?(camel)
      end

      normalized.slice(*PERMITTED_PARAMS)
    end
  end
end
