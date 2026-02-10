class Task < ApplicationRecord
  belongs_to :genre

  enum :priority, { low: 0, medium: 1, high: 2 }
  enum :status, { not_started: 0, in_progress: 1, completed: 2 }

  COPY_SUFFIX = '（コピー）'
  DUPLICATABLE_ATTRIBUTES = %w[name explanation genre_id priority].freeze

  def build_duplicate
    attrs = attributes.slice(*DUPLICATABLE_ATTRIBUTES)
    attrs["name"] = "#{attrs['name']}#{COPY_SUFFIX}"
    attrs["status"] = :not_started
    attrs["deadline_date"] = nil

    Task.new(attrs)
  end
end
