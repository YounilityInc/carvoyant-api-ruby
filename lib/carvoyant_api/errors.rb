module CarvoyantAPI
  class Errors < ActiveResource::Errors
    def from_json(json, save_cache = false)
      decoded = ActiveSupport::JSON.decode(json) || {} rescue {}
      errors = decoded['error'] || decoded
      from_hash errors, save_cache
    end

    def from_hash(messages, save_cache = false)
      clear unless save_cache

      messages["fieldErrors"].each do |field_error|
          key = field_error["fieldName"]
          error = field_error["errorDisplay"]
          if @base.known_attributes.include?(key)
            add key, error
          elsif key == 'base'
            self[:base] << error
          else
            # reporting an error on an attribute not in attributes
            # format and add them to base
            self[:base] << "#{key.humanize} #{error}"
          end
      end
    end
  end
end