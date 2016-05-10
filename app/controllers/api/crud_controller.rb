module Api	
	class Crudontroller < ApiController
		class_attribute :nesting
		if Rails.version >= '4.0'
		  class_attribute :permitted_attrs
		  class_attribute :allow_all_params
		end

		def index
			params[:current_user_id] = current_user.id
			entries = params[:scope].present? ? model_scope.send(params[:scope], params) : model_scope
			entries = entries.paginate(params) unless params[:scope] == 'paginate'
			render json: {status: "success", status_code: 200, data: entries.as_json({current_user_id: current_user.id, params: params})}
		end

		def show
			if entry
				render json: {status: "success", status_code: 200, data: entry.as_json({current_user_id: current_user.id})}
			else
				render json: {status: "error", status_code: 404, errors: [{code: 0, type: model_identifier, message: "No #{model_identifier} found with id #{params[:id]}"}]}, status: 404
			end
		end

		def new
			render json: {status: "success", status_code: 200, data: entry.as_json({current_user_id: current_user.id})}
		end

		def edit
			if entry
				render json: {status: "success", status_code: 200, data: entry.as_json({current_user_id: current_user.id})}
			else
				render json: {status: "error", status_code: 404, errors: [{code: 0, type: model_identifier, message: "No #{model_identifier} found with id #{params[:id]} to Edit"}]}, status: 404
			end
		end

		def create
			assign_attributes
			if entry.save
				render json: {status: "success", status_code: 200, data: entry.as_json({current_user_id: current_user.id, params: params})}
			else
				render json: {status: "error", status_code: 422}.merge(entry.error_messages), status: 422
			end
		end

		def update
			assign_attributes
			if entry.save
				render json: {status: "success", status_code: 200, data: entry.as_json({current_user_id: current_user.id})}
			else
				render json: {status: "error", status_code: 422}.merge(entry.error_messages), status: 422
			end
		end

		def destroy
			if entry.destroy
				render json: {status: "success", status_code: 200, data: {message: "#{params[:controller].titlecase} deleted successfully!", type: "#{params[:controller].titlecase} destroy", code: 555} }
			else
				render json: {status: "error", status_code: 422}.merge(entry.error_messages), status: 422
			end
		end

		def render_error
			message = env['action_dispatch.exception'].message # $!.message
			render json: {status: "error", status_code: params[:status].to_i, errors: [{message: message, type: Rack::Utils::HTTP_STATUS_CODES[params[:status].to_i], code: 333}] }
		end

		private

		def model_class
			params[:controller].camelize.demodulize.classify.constantize
		end

		def model_scope
			if nesting
				nesting.find(params["#{nesting.name.underscore.split('/').last}_id"]).send(model_class.name.underscore.split('/').last.pluralize.to_s)
			else
				model_class.all
			end
		end

		def entry
			@entry ||= params["id"] ? find_entry : new_entry
		end

		def find_entry
			exisiting_entry = nil
			begin
				existing_entry = model_class.find(params["id"])
			rescue Exception => e
				existing_entry = nil
			end
			existing_entry
		end

		def new_entry
			nesting ?  model_scope.new : model_class.new
		end

		def model_identifier
			model_class.model_name.param_key
		end

		def assign_attributes
			params[model_identifier][:user_id] = current_user.id if(entry.attributes.has_key?("user_id") && params[:action] == 'create')
			entry.attributes = model_params
		end

		def model_params
			if Rails.version < '4.0'
		    params[model_identifier]
			else
				allow_all_params ? params.require(model_identifier).permit! : params.require(model_identifier).permit(permitted_attrs)
			end
		end

	end
end
