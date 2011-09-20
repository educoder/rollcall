class Curnit < ActiveRecord::Base
  has_many :runs
  has_many :metadata, :as => :about, 
    :autosave => true, :dependent => :destroy
  
  include MetadataAccessorMixin
  include IdentifiableByNameMixin
  
  validates_uniqueness_of :name
  
  def to_s
    "#{name}"
  end
end
