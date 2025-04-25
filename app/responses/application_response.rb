class ApplicationResponse
  include Rails.application.routes.url_helpers

  class << self
    def default_url_options
      Rails.application.config.default_url_options
    end
  end
end