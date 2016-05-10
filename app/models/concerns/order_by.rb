module OrderBy
  extend ActiveSupport::Concern
  included do
    scope :order_by, ->(args = nil){ order("#{self.table_name}.#{ (args && args[:col]) || 'updated_at'} DESC") }
  end
end