class GroupMembership < ActiveRecord::Base
  belongs_to :group
  belongs_to :member, :polymorphic => true, :autosave => true
  
  validates_presence_of :group_id
  validates_presence_of :member_id
  validates_presence_of :member_type
  validate :validate_uniqueness_of_members
  
  protected
    def validate_uniqueness_of_members
      already_exists = GroupMembership.exists?(
        :group_id => group_id,
        :member_id => member_id,
        :member_type => member_type
      )
      
      if already_exists
        errors[:base] << "#{group} already has a #{member_type} with id #{member_id}"
      end 
    end
end
