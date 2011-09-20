class Group < ActiveRecord::Base
  belongs_to :run
  
  # for items belonging to this group
  has_many :memberships, :class_name => GroupMembership.name, 
    :autosave => true, :dependent => :destroy
    
  # for groups (supergroups) that this group belongs to
  has_many :group_memberships, :as => :member,
    :autosave => true, :dependent => :destroy
  has_many :groups, :through => :group_memberships
  
  include MetadataAccessorMixin
  include IdentifiableByNameMixin
  include AccountMixin
  
  validates_presence_of :run_id
  validate :check_for_member_self
  
  def members
    memberships.collect{|membership| membership.member}
  end
  
  def add_member(member)
    memberships.build(:member => member)
  end
  alias_method :<<, :add_member
  
  def to_s
    name
  end
  
  def check_for_member_self
    memberships.each do |membership|
      if membership.member == self
        errors.add(:memberships, "cannot contain the group itself")
      end
    end
  end
end
