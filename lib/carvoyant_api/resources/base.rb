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

      def headers
        if defined?(@headers)
          @headers
        elsif superclass != Object && superclass.headers
          superclass.headers
        else
          @headers ||= {}
        end
      end

      def activate_session(token)
        headers.merge!({ 'Authorization' => "Bearer #{token}" })
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
      load_remote_errors(@remote_errors, true)
      false
    end

    def errors
      @errors ||= Errors.new(self)
    end
  end
end