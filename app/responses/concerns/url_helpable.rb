module UrlHelperable
  extend ActiveSupport::Concern

  included do
    include Rails.application.routes.url_helpers
  end

  class_methods do
    def default_url_options
      Rails.application.config.default_url_options
    end
  end
end