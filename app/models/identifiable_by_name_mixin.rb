module IdentifiableByNameMixin
  def self.included(target)
    target.class_eval do
      def self.find_by_name_or_id(name_or_id)
        if name_or_id =~ /^\d+/
          find(name_or_id)
        else
          find(:first, :conditions => {'name' => name_or_id}) or
            raise ActiveRecord::RecordNotFound, "#{self} #{name_or_id.inspect} doesn't exist!"
        end
      end
    end
  end
end