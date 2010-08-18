class User < ActiveRecord::Base
  KINDS = ['Student', 'Instructor', 'Admin']
  
  has_many :sessions,
    :dependent => :destroy
  
  has_many :group_memberships, :as => :member,
    :autosave => true, :dependent => :destroy
  has_many :groups, :through => :group_memberships
  
  has_many :metadata, :as => :about, :autosave => true,
    :autosave => true, :dependent => :destroy
  
  include MetadataAccessorMixin

  def to_s
    "#{display_name} (#{username})"
  end

end
