module CarvoyantAPI
  class Base < ActiveResource::Base
    self.site = 'https://api.carvoyant.com'
    self.prefix = '/v1/api/'

    class << self
      def element_path(id, prefix_options = {}, query_options = nil)
        check_prefix_options(prefix_options)
        prefix_options, query_options = split_options(prefix_options) if query_options.nil?
        "#{prefix(prefix_options)}#{element_name}/#{URI.parser.escape id.to_s}#{query_string(query_options)}"
      end

      def collection_path(prefix_options = {}, query_options = nil)
        prefix_options, query_options = split_options(prefix_options) if query_options.nil?
        "#{prefix(prefix_options)}#{element_name}/#{query_string(query_options)}"  
      end

      def token_string
        Thread.current["active.resource.token_strings.#{self.object_id}"]
      end

      def token_string=(str)
        Thread.current["active.resource.token_strings.#{self.object_id}"] = str
      end

      def headers
        super.merge({ 'Authorization' => "Bearer #{token_string}" })
      end
    end

    def update
      run_callbacks :update do
        connection.post(element_path(prefix_options), encode, self.class.headers).tap do |response|
          load_attributes_from_response(response)
        end
      end
    end

    def save
      super
    rescue ActiveResource::ServerError, ActiveResource::ResourceInvalid => error
      @remote_errors = error
      byebug
      load_remote_errors(@remote_errors, true)
      false
    end

    def errors
      @errors ||= Errors.new(self)
    end
  end
end