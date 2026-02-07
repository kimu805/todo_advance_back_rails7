class ApplicationService
  def self.call(...)
    new(...).call
  end

  private

  def normalize_params(params)
    params.to_h.transform_keys { |key| key.to_s.underscore.to_sym }
  end
end
