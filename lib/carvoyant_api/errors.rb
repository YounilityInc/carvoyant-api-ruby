module CarvoyantAPI
  # CarvoyantAPI Validation Errors are returned in a specific format. By default ActiveResource is unable to parse API errors correctly.
  # ActiveResource `from_json` and `from_hash` methods need to be overridden to correctly parse errors returned by CarvoyantAPI
  class Errors < ActiveResource::Errors
    def from_json(json, save_cache = false)
      decoded = ActiveSupport::JSON.decode(json) || {} rescue {}
      errors = decoded['error'] || decoded
      from_hash errors, save_cache
    end

    def from_hash(messages, save_cache = false)
      unless save_cache
        clear
      end

      if messages['fieldErrors']
        messages['fieldErrors'].each do |field_error|
            key = field_error['fieldName']
            error = field_error['errorDisplay']
            if @base.known_attributes.include?(key)
              add key, error
            elsif key == 'base'
              self[:base] << error
            else
              # Errors that might have an unknown key should be added to base
              self[:base] << "#{key.humanize} #{error}"
            end
        end
      elsif messages['errorDisplay']
        self[:base] << messages['errorDisplay']
      else
        self[:base] << 'An unknown error has occured.'
      end
    end

    # CarvoyantAPI returns error messages which have attribute name in the message.
    # For example: "The deviceId is in use by another vehicle."
    # Overrides ActiveModel::Errors method
    def full_message(attribute, message)
      I18n.t(:"carvoyant_errors.format", {
        default: '%{message}',
        message: message,
        attribute: attribute
      })
    end
  end
end