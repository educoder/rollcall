class Run < ActiveRecord::Base
  belongs_to :curnit
  has_many :groups
  has_many :metadata, :as => :about,
    :autosave => true, :dependent => :destroy
  
  include MetadataAccessorMixin
  
  validates_presence_of :curnit_id
  validates_uniqueness_of :name
  
  def to_s
    "#{curnit}: #{name}"
  end
end
