class Group < ActiveRecord::Base
  belongs_to :run
  
  has_many :metadata, :as => :about, 
    :autosave => true, :dependent => :destroy

  # for items belonging to this group
  has_many :memberships, :class_name => GroupMembership.name, 
    :autosave => true, :dependent => :destroy
    
  # for groups (supergroups) that this group belongs to
  has_many :group_memberships, :as => :member,
    :autosave => true, :dependent => :destroy
  has_many :groups, :through => :group_memberships
  
  include MetadataAccessorMixin
  
  validates_presence_of :run_id
  
  def members
    memberships.collect{|membership| membership.member}
  end
  
  def to_s
    name
  end
end
