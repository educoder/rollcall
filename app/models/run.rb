class Run < ActiveRecord::Base
  belongs_to :app
  has_many :groups
  has_many :metadata, :as => :about,
    :autosave => true, :dependent => :destroy
  
  include MetadataAccessorMixin
  
  validates_presence_of :app_id
  
  def to_s
    "#{app}: #{name}"
  end
end
