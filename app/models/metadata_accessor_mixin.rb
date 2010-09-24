module MetadataAccessorMixin
  def self.included(target)
    target.class_eval do
      alias_method :_metadata, :metadata
      
      def to_xml(*args)
        add_metadata_to_serialization_options(*args)
        super(*args)
      end
      
      def as_json(*args)
        add_metadata_to_serialization_options(*args)
        super(*args)
      end
      
      def metadata
        MetadataAccessor.new(self)
      end
      
      private
        def add_metadata_to_serialization_options(*args)
          args[0] ||= {}

          methods = args[0][:methods]
          methods = [methods] unless methods.is_a?(Array)

          if methods.empty? || methods == [nil]
            args[0][:methods] = :metadata
          elsif !methods.include?(:metadata)
            args[0][:methods] = methods << :metadata
          end
        end
    end
  end
  
  class MetadataAccessor
    def initialize(about)
      @about = about
    end
    
    def to_xml(opts = {})
      xml = opts[:builder] || ::Builder::XmlMarkup.new(:indent => 2)
      xml.metadata do |metadata_xml|
        @about._metadata.each do |datum|
          metadata_xml.tag!(datum.key, datum.value)
        end
      end
    end
    
    def as_json(opts = {})
      json = {}
      @about._metadata.each do |datum|
        json[datum.key] = datum.value
      end
      return json
    end
    
    def replace(attrs)
      attrs.each {|key, val| self[key] = val}
    end
    
    def [](key)
      @about._metadata.find_by_key(key.to_s)
    end
    
    def []=(key, value)
      datum = @about._metadata.find_by_key(key)
      if datum
        datum.value = value
      else
        @about._metadata.build(:key => key, :value => value)
      end
    end
    
    def to_s
      HashWithIndifferentAccess.new Hash[@about._metadata.find(:all).collect{|md| [md.key, md.value]}]
    end
  end
end