module ErrorMessages
  extend ActiveSupport::Concern

  def error_messages(options = nil)
    response = {errors: []}
    options ||= {}
    error_messages = errors.as_json(full_messages: true)
    table_number = self.class.connection.tables.index(self.class.table_name).to_s
    error_messages.each do |col, errors|
      error_code = table_number + self.class.column_names.index(col.to_s).to_s
      data =  {:code => options[:code] || error_code}
      data[:type] = options[:type] || self.class.name
      data[:message] = errors.uniq.join(',')
      response[:errors] << data
    end
    response
  end

end

ActiveRecord::Base.send(:include, ErrorMessages)
