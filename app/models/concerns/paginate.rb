module Paginate
  extend ActiveSupport::Concern
  included do
    scope :paginate, ->(args){ offset( ((args[:perPage].present? ? args[:perPage].to_i : 10) * (args[:pageNo].present? ? args[:pageNo].to_i : 1)) - (args[:perPage].present? ? args[:perPage].to_i : 10)).limit(args[:perPage].present? ? args[:perPage].to_i : 10) }
  end
end
