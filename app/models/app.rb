class App < ActiveRecord::Base
  has_many :runs
  has_many :metadata, :as => :about, 
    :autosave => true, :dependent => :destroy
  
  include MetadataAccessorMixin
  
  def to_s
    "#{name}"
  end
end
