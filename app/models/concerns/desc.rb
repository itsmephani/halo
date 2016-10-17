module Desc
  extend ActiveSupport::Concern
  included do
    scope :desc, ->(args = nil){ order("#{self.table_name}.updated_at DESC") }
  end
end