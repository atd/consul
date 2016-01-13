module Filterable
  extend ActiveSupport::Concern

  included do
    scope :by_author,         -> (username)       { where(users: { username: username }).includes(:author) }
    scope :by_official_level, -> (official_level) { where(users: { official_level: official_level }).includes(:author) }
    scope :by_date_range,     -> (date_range)     { where(created_at: date_range) }
  end

  class_methods do

    def filter(params)
      resources = self.all
      params.each do |filter, value|
        if allowed_filter?(filter, value)
          resources = resources.send("by_#{filter}", value)
        end
      end
      resources
    end

    def allowed_filter?(filter, value)
      return if value.blank?
      ['author', 'official_level', 'date_range'].include?(filter)
    end

  end

end