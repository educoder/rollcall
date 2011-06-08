module MetadataAccessorMixin
  def self.included(target)
    target.class_eval do
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
      
      has_many :metadata_pairs, :as => :about,
        :class_name => 'Metadata',
        :autosave => true, :dependent => :destroy
      
      accepts_nested_attributes_for :metadata_pairs,
        :allow_destroy => true,
        :reject_if => proc { |attributes| attributes['key'].blank? }
      
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
        # FIXME: hack to prevent weird behaviour in ActiveResource
        #        when metadata is empty (can't seem to add metadata when
        #        it is initially empty)
        if @about.metadata_pairs.empty?
          metadata_xml.tag!('key', 'value')
        end
        @about.metadata_pairs.each do |datum|
          metadata_xml.tag!(datum.key, datum.value)
        end
      end
    end
    
    def as_json(opts = {})
      json = {}
      @about.metadata_pairs.each do |datum|
        json[datum.key] = datum.value
      end
      return json
    end
    
    def replace(attrs)
      attrs.each {|key, val| self[key] = val}
    end
    
    def [](key)
      datum = @about.metadata_pair.to_s.detect{|m| m.key.to_s == key.to_s} || # for newly added keys
        @about.metadata_pair.find_by_key(key.to_s)
        
      datum ? datum.value : nil
    end
    
    def []=(key, value)
      idx = @about.metadata_pair.to_a.find_index{|m| m.key.to_s == key.to_s}
      
      if idx
        # FIXME: this commits the update of the value immediately, which may be unexpected 
        #        or undersirable (new keys don't get commited until after parent is saved)
        @about.metadata_pair[idx].value = value
      else
        @about.metadata_pair.build(:key => key.to_s, :value => value)
        puts "value"
      end
    end
    
    def each
      @about.metadata_pair.find(:all).each do |datum|
        yield datum
      end
    end
    
    def to_s
      HashWithIndifferentAccess.new Hash[@about.metadata_pair.find(:all).collect{|md| [md.key, md.value]}]
    end
  end
end