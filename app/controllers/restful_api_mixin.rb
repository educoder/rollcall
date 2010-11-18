module RestfulApiMixin
  def render_error(error)
    status = :internal_server_error
    unless error.is_a?(RestfulError)
      status = Rack::Utils.status_code(ActionDispatch::ShowExceptions.rescue_responses[error.class.name])
      error = RestfulError.new(error)
    end
    respond_to do |format|
      format.xml { render :xml => error.to_xml, :status => status }
    end
  end
  
  def self.included(controller)
    controller.rescue_from ActiveRecord::RecordNotFound, :with => :render_error
  end
  
  class RestfulError
    attr_reader :error
    attr_reader :type
    
    def initialize(error, type = nil)
      @error = error
      @type = type
    end
    
    def to_xml
      xml = ::Builder::XmlMarkup.new(:indent => 2)
      
      xml.instruct!
      xml.error do |err|
        case @error
        when String
          err.message @error
        when Hash
          @error.each do |key, val|
            err.tag!(key, val)
          end
        when Array
          @error.each do |val|
            err.message val
          end
        when Exception
          err.message @error.message
          err.type @error.class
        else
          err.message @error.inspect
        end
      end
    end
    
    def to_json
      json = {}
      case @error
      when String
        json[:message] = @error
      when Hash
        err.each do |key, val|
          json[key] = val
        end
      when Array
        json[:message] = []
        @error.each do |val|
          json[:message] << val
        end
      when Exception
        json[:message] = @error.message
        json[:type] = @error.class
      else
        json[:message] = @error.inspect
      end
    end
  end
end